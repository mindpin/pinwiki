class CreateWikiPages < ActiveRecord::Migration
  def change
    create_table :wiki_pages do |t|
      t.integer :creator_id
      t.string :title
      t.text :content
      t.integer :latest_version

      t.timestamps
    end
  end
end
