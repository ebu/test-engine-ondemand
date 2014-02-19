class CreatePresetTemplates < ActiveRecord::Migration
  def change
    create_table :preset_templates do |t|
      t.text :template_text
      t.integer :preset_type, default: 0
      t.timestamps
    end
  end
end
