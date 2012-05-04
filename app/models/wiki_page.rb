class WikiPage < ActiveRecord::Base
  # --- 模型关联
  has_many :audits, :class_name => 'Audit', :foreign_key => :auditable_id
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  audited :associated_with => :creator
  
  
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
