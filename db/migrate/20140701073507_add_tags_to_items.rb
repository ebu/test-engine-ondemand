class AddTagsToItems < ActiveRecord::Migration
  def change
    add_column :encoding_jobs, :device_playout_tags, :text
    add_column :encoding_jobs, :specification_tags, :text
    add_column :encoding_jobs, :combined_tags, :text
    add_column :preset_templates, :tags, :text
  end
end
