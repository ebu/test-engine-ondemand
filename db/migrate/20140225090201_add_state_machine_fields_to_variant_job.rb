class AddStateMachineFieldsToVariantJob < ActiveRecord::Migration
  def change
    add_column :variant_jobs, :status, :integer, default: 0
    add_column :variant_jobs, :codem_id, :string
    add_column :variant_jobs, :transcoder_id, :integer
  end
end
