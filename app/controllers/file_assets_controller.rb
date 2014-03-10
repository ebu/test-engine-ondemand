class FileAssetsController < PlugitController
  before_filter :require_login
  
  def index
    @file_assets = FileAsset.where(user_id: logged_in_user.ebu_id).order("created_at DESC")
  end
  
  def create
    @file_asset = FileAsset.new(user_params)
    @file_asset.user_id = logged_in_user_id
    @file_asset.save!
    render :ok, nothing: true
  end
  
  def destroy
    @file_asset = FileAsset.find(params[:id])
    if @file_asset.user_id == logged_in_user.ebu_id && @file_asset.destroy
      flash[:notice] = "File removed."
    else
      flash[:alert] = "Unable to remove file."
    end
    redirect_to file_assets_path
  end
  
  private
  
  def user_params
    params.require(:file_asset).permit(:resource, :user_id)
  end
end
