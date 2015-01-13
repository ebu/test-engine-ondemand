# Controller managing the organizations that have write access to the application.
class OrganizationsController < ApplicationController
  before_filter :update_organizations, only: [ :index ]
  
  def index
    @organizations = Organization.all
  end
  
  def update_multiple
    ids = params[:organization_ids] || []
    Organization.all.each do |o|
      allow_rw = (ids.include?(o.id.to_s) ? true : false)
      o.update_attribute(:can_write, allow_rw)
    end
    flash[:notice] = "Updated organizations."
    redirect_to organizations_path
  end
  
  private
  
  def update_organizations
    Organization.refresh
  end
end
