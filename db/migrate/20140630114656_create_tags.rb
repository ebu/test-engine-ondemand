class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :tag_type, default: 0

      t.timestamps
    end
    
    add_index :tags, :tag_type
  end
end
