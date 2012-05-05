class WikiPageVersion < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :wiki_page
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_associated_audits
      base.has_many :wiki_page_versions, :foreign_key => :creator_id

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      #Todo
    end
  end
end
