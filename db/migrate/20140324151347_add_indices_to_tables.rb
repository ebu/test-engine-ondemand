class AddIndicesToTables < ActiveRecord::Migration
  def change
    # Add indices to codem_notifications
    add_index :codem_notifications, :notified_at
    add_index :codem_notifications, :codem_id
    add_index :codem_notifications, :status
    
    # Add indices to encoding_jobs
    add_index :encoding_jobs, :status
    add_index :encoding_jobs, :is_reference
    add_index :encoding_jobs, :created_at
    
    # Add indices to file assets
    add_index :file_assets, :created_at
    add_index :file_assets, :is_reference
    
    # Add indices to preset templates
    add_index :preset_templates, :preset_type
    add_index :preset_templates, :user_id
    add_index :preset_templates, :is_reference
    
    # Add indices to remote jobs
    add_index :remote_jobs, :remote_id
    
    # Add indices to users
    add_index :users, :ebu_id
    add_index :users, :organization_id
    
    # Add indices to variant jobs
    add_index :variant_jobs, :encoding_job_id
    add_index :variant_jobs, :codem_id
  end
end
