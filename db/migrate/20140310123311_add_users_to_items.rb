class AddUsersToItems < ActiveRecord::Migration
  def change
    add_column :encoding_jobs, :user_id, :integer
    add_column :preset_templates, :user_id, :integer
    add_column :file_assets, :user_id, :integer
  end
end
