class AddDestinationFilePathToVariantJobs < ActiveRecord::Migration
  def change
    add_column :variant_jobs, :destination_file_path, :string
  end
end
