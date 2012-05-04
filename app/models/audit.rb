class Audit < ActiveRecord::Base
  # --- 模型关联
  belongs_to :wiki_page, :class_name => 'WikiPage', :foreign_key => :auditable_id
  belongs_to :creator, :class_name => 'User', :foreign_key => ':user_id'
end
