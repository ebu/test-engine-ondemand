class ChangeResourceFileSize < ActiveRecord::Migration
  def up
    change_column :file_assets, :resource_file_size, :bigint
  end
  
  def down
    change_column :file_assets, :resource_file_size, :integer
  end
end
