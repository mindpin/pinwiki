class Audit < ActiveRecord::Base
  # --- 模型关联
  belongs_to :wiki_page, :class_name => 'WikiPage', :foreign_key => :auditable_id
  belongs_to :creator, :class_name => 'User', :foreign_key => :user_id
  has_one :wiki_page_version, :class_name => 'WikiPageVersion', :foreign_key => :audit_id
  
  #　所有要回滚的记录
  def self.find_rollback_versions(id)
    Audit.where('id > ?', id).order("version DESC").all
  end
  
  #　只查找单个页面要回滚的记录
  def self.find_rollback_pages(id, auditable_id)
    Audit.where('id > ? and auditable_id = ?', id, auditable_id).order("version DESC").all
  end
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :audits, :foreign_key => :user_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      #Todo
    end
  end
end
