class WikiPage < ActiveRecord::Base
  # --- 模型关联
  has_many :audits, :class_name => 'Audit', :foreign_key => :auditable_id
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
