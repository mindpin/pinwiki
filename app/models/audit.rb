class Audit < ActiveRecord::Base
  # --- 模型关联
  belongs_to :wiki_page, :class_name => 'WikiPage', :foreign_key => :auditable_id
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  has_one :wiki_page_version, :class_name => 'WikiPageVersion', :foreign_key => :audit_id

  def page_version

    audited_changes = self.audited_changes
    if audited_changes.class.equal?(String)
      audited_changes = YAML.load(audited_changes)
    end


    case self.action
    when "create"
      id = self.auditable_id
      title = audited_changes['title']
      content = audited_changes['content']

    when "update"
      title = audited_changes['title'][self.version - 2]
      content = audited_changes['content'][self.version - 2]

    when "destroy"
      title = audited_changes['title']
      content = audited_changes['content']
      creator_id = audited_changes['creator_id']
    end

    {'id' => self.auditable_id, 'title' => title, 'content' => content}

  end




=begin
  def prev
    self.wiki_page.audits.find_by_version(self.version-1)
  end
=end
  
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
