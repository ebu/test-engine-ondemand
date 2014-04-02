class AddForumUrlToEncodingJob < ActiveRecord::Migration
  def change
    add_column :encoding_jobs, :forum_url, :string
  end
end
