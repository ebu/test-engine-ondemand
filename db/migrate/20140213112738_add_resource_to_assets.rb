class AddResourceToAssets < ActiveRecord::Migration
  def up
    add_attachment :assets, :resource
  end
  
  def down
    remove_attachment :assets, :resource
  end
end
