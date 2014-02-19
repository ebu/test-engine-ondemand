class AddPostProcessingTemplateIdToEncodingJob < ActiveRecord::Migration
  def change
    add_column :encoding_jobs, :post_processing_template_id, :integer
  end
end
