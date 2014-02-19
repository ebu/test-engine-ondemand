class AddDescriptionToPresetTemplate < ActiveRecord::Migration
  def change
    add_column :preset_templates, :description, :string
  end
end
