class AddRemoteJobIdsToEncodingJob < ActiveRecord::Migration
  def change
    add_column :encoding_jobs, :post_processing_job_id, :integer
    add_column :encoding_jobs, :conformance_checking_job_id, :integer
  end
end
