class AssetsController < ApplicationController
  def index
    @assets = Asset.order("created_at DESC")
  end
  
  def create
    @asset = Asset.new user_params
    if @asset.save
      flash[:notice] = "File uploaded."
    else
      flash[:alert] = "Unable to upload file."
    end
    redirect_to assets_path
  end
  
  private
  
  def user_params
    params.require(:asset).permit(:resource)
  end
end
