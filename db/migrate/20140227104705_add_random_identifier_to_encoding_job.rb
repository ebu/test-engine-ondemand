class AddRandomIdentifierToEncodingJob < ActiveRecord::Migration
  def change
    add_column :encoding_jobs, :random_id, :string
  end
end
