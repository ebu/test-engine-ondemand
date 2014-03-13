class RenameOrganisationToOrganization < ActiveRecord::Migration
  def change
    rename_column :users, :organisation_name, :organization_name
    rename_column :users, :organisation_id, :organization_id
  end
end
