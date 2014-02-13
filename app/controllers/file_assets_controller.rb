class FileAssetsController < ApplicationController
  def index
    @file_assets = FileAsset.order("created_at DESC")
  end
  
  def create
    if FileAsset.create(user_params)
      flash[:notice] = "File uploaded."
    else
      flash[:alert] = "Unable to upload file."
    end
    redirect_to file_assets_path
  end
  
  private
  
  def user_params
    params.require(:file_asset).permit(:resource)
  end
end
