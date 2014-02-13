class AddResourceToAssets < ActiveRecord::Migration
  def up
    add_attachment :file_assets, :resource
  end
  
  def down
    remove_attachment :file_assets, :resource
  end
end
