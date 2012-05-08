class WikiPageVersion < ActiveRecord::Base
  # --- 模型关联
  belongs_to :wiki_page
  belongs_to :audit, :class_name => 'Audit', :foreign_key => :audit_id
  
  def prev
    WikiPageVersion.where('wiki_page_id = ? and audit_id < ?', self.wiki_page_id, self.audit_id).order('id DESC').first
  end
  

  # --- 给其他类扩展的方法
  
end
