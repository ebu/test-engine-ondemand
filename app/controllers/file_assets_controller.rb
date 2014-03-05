class FileAssetsController < PlugitController
  before_filter :require_login
  
  def index
    @file_assets = FileAsset.order("created_at DESC")
  end
  
  def create
    @file_asset = FileAsset.create!(user_params)
    render :ok, nothing: true
  end
  
  def destroy
    @file_asset = FileAsset.find(params[:id])
    if @file_asset.destroy
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
