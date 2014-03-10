class AddReferenceStatusToItems < ActiveRecord::Migration
  def change
    add_column :encoding_jobs, :is_reference, :boolean, default: false, null: false
    add_column :preset_templates, :is_reference, :boolean, default: false, null: false
    add_column :file_assets, :is_reference, :boolean, default: false, null: false
  end
end
