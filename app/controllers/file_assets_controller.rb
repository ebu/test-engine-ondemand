class FileAssetsController < ApplicationController
  def index
    @file_assets = FileAsset.order("created_at DESC")
  end
  
  def create
    @file_asset = FileAsset.new(user_params)
    if @file_asset.save
      flash[:notice] = "File uploaded."
    else
      flash[:alert] = "Unable to upload file. Please make sure it is a valid video, audio or subtitle file."
    end
    redirect_to file_assets_path
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
