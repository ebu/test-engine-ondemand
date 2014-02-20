class CreateVariantJobs < ActiveRecord::Migration
  def change
    create_table :variant_jobs do |t|
      t.integer :encoding_job_id
      t.integer :encoder_preset_template_id
      t.integer :source_file_id
      t.string :source_file_path
      t.string :encoder_flags
      t.timestamps
    end
  end
end
