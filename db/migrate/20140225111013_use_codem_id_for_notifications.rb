class UseCodemIdForNotifications < ActiveRecord::Migration
  def up
    add_column :codem_notifications, :codem_id, :string
    remove_column :codem_notifications, :variant_job_id
  end
  
  def down
    remove_column :codem_notifications, :codem_id
    add_column :codem_notifications, :variant_job_id, :integer
  end
end
