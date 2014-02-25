class RenameStateToStatus < ActiveRecord::Migration
  def change
    rename_column :codem_notifications, :state, :status
  end
end
