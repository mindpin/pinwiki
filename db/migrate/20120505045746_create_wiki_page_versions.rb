class CreateWikiPageVersions < ActiveRecord::Migration
  def change
    create_table :wiki_page_versions do |t|
      t.integer :creator_id
      t.integer :wiki_page_id
      t.string :title
      t.text :content
      t.integer :version
      
      t.timestamps
    end
  end
end
