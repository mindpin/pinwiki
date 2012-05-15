class RemoveWikiPageVersions < ActiveRecord::Migration
  def change
    drop_table :wiki_page_versions
  end
end
