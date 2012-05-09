class Audit < ActiveRecord::Base
  # --- 模型关联
  belongs_to :wiki_page, :class_name => 'WikiPage', :foreign_key => :auditable_id
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  has_one :wiki_page_version, :class_name => 'WikiPageVersion', :foreign_key => :audit_id

  
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
