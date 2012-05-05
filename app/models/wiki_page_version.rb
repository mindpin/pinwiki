class WikiPageVersion < ActiveRecord::Base
  # --- 模型关联
  belongs_to :wiki_page
  belongs_to :audit, :class_name => 'Audit', :foreign_key => :version
  
  # --- 给其他类扩展的方法
  
end
