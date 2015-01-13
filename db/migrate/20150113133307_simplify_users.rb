class SimplifyUsers < ActiveRecord::Migration
  def up
    add_column    :users, :uid, :string
    add_index     :users, :uid
    remove_column :users, :ebu_id
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :organization_name
    remove_column :users, :organization_id
    remove_column :users, :username
  end
  
  def down
    add_column    :users, :ebu_id, :integer
    add_column    :users, :first_name, :string
    add_column    :users, :last_name, :string
    add_column    :users, :organization_name, :string
    add_column    :users, :organization_id, :integer
    add_column    :users, :username, :string
    remove_column :users, :uid
  end
end
