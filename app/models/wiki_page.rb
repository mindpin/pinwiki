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
      :wiki_page_id => self.id,
      :audit_id => Audit.last.id,
      :title => self.title, 
      :content => self.content
    )
  end
  
  #　只查找单个页面要回滚的记录
  def find_rollback(id)
    Audit.where('id > ? and auditable_id = ?', id, self.id).order("version DESC").all
  end
  
  
  def self.system_rollback(audit)
    case audit.action
      when 'create'
        wiki_page = WikiPage.find(audit.auditable_id)
        wiki_page.destroy unless wiki_page.nil?

      when 'update'
        # page = audit.audited_changes.each_line.map {|l| l.split(':').last.strip}

        wiki_page = WikiPage.find(audit.auditable_id)

        wiki_page.title = audit.wiki_page_version.prev.title
        wiki_page.content = audit.wiki_page_version.prev.content
        wiki_page.creator_id = audit.wiki_page_version.prev.creator_id
        wiki_page.save
     
      when 'destroy'
        wiki_page = WikiPage.new

        wiki_page.id = audit.wiki_page_version.wiki_page_id
        wiki_page.title = audit.wiki_page_version.title
        wiki_page.content = audit.wiki_page_version.content
        wiki_page.creator_id = audit.wiki_page_version.creator_id
        
        wiki_page.save

    end
  end
  
  
  def rollback(audit)
    case audit.action
      when 'create'
        self.destroy unless self.nil?

      when 'update'
        self.title = audit.wiki_page_version.prev.title
        self.content = audit.wiki_page_version.prev.content
        self.creator_id = audit.wiki_page_version.prev.creator_id
        self.save
     
      when 'destroy'
        self.id = audit.wiki_page_version.wiki_page_id
        self.title = audit.wiki_page_version.title
        self.content = audit.wiki_page_version.content
        self.creator_id = audit.wiki_page_version.creator_id
        
        self.save

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
