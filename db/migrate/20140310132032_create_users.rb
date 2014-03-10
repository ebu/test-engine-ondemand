class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :ebu_id
      t.string :first_name
      t.string :last_name
      t.string :organisation_name
      t.integer :organisation_id
      t.string :username
      t.timestamps
    end
  end
end
