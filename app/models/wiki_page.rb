class WikiPage < ActiveRecord::Base
  # --- 模型关联
  # has_many :audits, :class_name => 'Audit', :foreign_key => :auditable_id
  has_many :versions, :class_name => 'WikiPageVersion', :foreign_key => :wiki_page_id
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  audited :associated_with => :creator
  
  after_save :create_new_version
  before_destroy :create_new_version
  
  def create_new_version
    WikiPageVersion.create(
      :creator_id => self.creator_id,
      :wiki_page_id => self.id,
      :audit_id => self.audits.last.id,
      :title => self.title, 
      :content => self.content
    )
  end


  def rollback(audit)
    audits = Audit.where('id > ? and auditable_id = ?', audit.id, self.id).order("id DESC").all

    audits.each do |audit|
      case audit.action
        when 'create'
          wiki_page = WikiPage.find(self.id)
          wiki_page.destroy
  
        when 'update'
=begin
          self.title = audit.wiki_page_version.prev.title
          self.content = audit.wiki_page_version.prev.content
          self.creator_id = audit.wiki_page_version.prev.creator_id
=end
          data = audit.page_version
          self.title = data['title']
          self.content = data['content']
          self.creator_id = audit.user_id
          self.save
       
        when 'destroy'
=begin
          wiki_page = WikiPage.new(
            :id => audit.wiki_page_version.wiki_page_id,
            :title => audit.wiki_page_version.title,
            :content => audit.wiki_page_version.content,
            :creator_id => audit.wiki_page_version.creator_id
          )
=end
          data = audit.page_version
          wiki_page = WikiPage.new(
            :id => audit.auditable_id,
            :title => data['title'],
            :content => data['content'],
            :creator_id => audit.user_id
          )
          wiki_page.save
      end
    end
    
  end


  def self.system_rollback(audit)
    audits = Audit.where('id > ?', audit.id).order("id DESC").all
    
    audits.each do |audit|
      case audit.action
        when 'create'
          wiki_page = WikiPage.find(audit.auditable_id)
          wiki_page.destroy unless wiki_page.nil?
  
        when 'update'
          # page = audit.audited_changes.each_line.map {|l| l.split(':').last.strip}
  
          wiki_page = WikiPage.find(audit.auditable_id)

          data = audit.page_version
  
          wiki_page.title = data['title']
          wiki_page.content = data['content']
          wiki_page.creator_id = audit.user_id
          wiki_page.save
       
        when 'destroy'
          wiki_page = WikiPage.new

          data = audit.page_version
  
          wiki_page.id = audit.auditable_id
          wiki_page.title = data['title']
          wiki_page.content = data['content']
          wiki_page.creator_id = audit.user_id
          
          wiki_page.save
      end
      
    end
    
  end
  

  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_associated_audits
      base.has_many :wiki_pages, :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      #Todo
    end
  end
end
