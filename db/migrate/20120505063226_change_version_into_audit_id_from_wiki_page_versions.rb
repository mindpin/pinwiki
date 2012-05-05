class ChangeVersionIntoAuditIdFromWikiPageVersions < ActiveRecord::Migration
  def change
    rename_column :wiki_page_versions, :version, :audit_id
  end
end
