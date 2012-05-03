class WikiPage < ActiveRecord::Base
  audited
  
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  has_associated_audits
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :wiki_pages, :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      #Todo
    end
  end
end
