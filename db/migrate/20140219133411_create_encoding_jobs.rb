class CreateEncodingJobs < ActiveRecord::Migration
  def change
    create_table :encoding_jobs do |t|
      t.string :description
      t.text :post_processing_flags
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
