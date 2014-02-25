class AddMessageToCodemNotifications < ActiveRecord::Migration
  def change
    add_column :codem_notifications, :message, :text
  end
end
