class CreateCodemNotifications < ActiveRecord::Migration
  def change
    create_table :codem_notifications do |t|
      t.integer :variant_job_id
      t.string :state
      t.decimal :notified_at, precision: 15, scale: 3
      t.timestamps
    end
  end
end
