class OrganizationsController < PlugitController
  before_filter :require_admin
  
  def index
    @organizations = Organization.all
  end
  
  def update_multiple
    Organization.all.each do |o|
      allow_rw = (params[:organization_ids].include?(o.id.to_s) ? true : false)
      o.update_attribute(:can_write, allow_rw)
    end
    flash[:notice] = "Updated organizations."
    redirect_to organizations_path
  end
end
