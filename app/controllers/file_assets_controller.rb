# Controller managing all the file assets/uploads.
class FileAssetsController < ApplicationController
  # Only login required for index
  before_filter :require_login, only: [ :index, :create, :destroy ]
  
  def index
    @file_assets = FileAsset.owned(logged_in_user).order("created_at DESC")
    @referenced_file_assets = FileAsset.referenced
  end
  
  def create
    @file_asset = FileAsset.new(user_params)
    @file_asset.user = logged_in_user
    @file_asset.save!
    render :ok, nothing: true
  end
  
  def destroy
    @file_asset = FileAsset.find(params[:id])
    if @file_asset.can_be_destroyed_by?(logged_in_user) && @file_asset.destroy
      flash[:notice] = "File removed."
    else
      flash[:alert] = "Unable to remove file."
    end
    redirect_to file_assets_path
  end
  
  private
  
  def user_params
    params.require(:file_asset).permit(:resource)
  end
end
