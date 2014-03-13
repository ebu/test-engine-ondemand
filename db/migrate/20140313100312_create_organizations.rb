class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.integer :ebu_id, null: false
      t.boolean :can_write, default: false, null: false
      t.timestamps
    end
  end
end
