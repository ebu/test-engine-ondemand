class TranscodersController < PlugitController
  before_filter :require_login

  def index
    @transcoders = Transcoder.all
  end
  
  def new
    @transcoder = Transcoder.new
  end
  
  def create
    @transcoder = Transcoder.new(user_params)
    if @transcoder.save
      flash[:notice] = "Transcoder created."
      redirect_to transcoders_path
    else
      flash[:alert] = "Unable to create transcoder."
      render :new
    end
  end
  
  def destroy
    @transcoder = Transcoder.find(params[:id])
    if @transcoder.destroy
      flash[:notice] = "Transcoder removed."
    else
      flash[:alert] = "Unable to remove transcoder."
    end
    redirect_to transcoders_path
  end
  
  def available
    @transcoder = Transcoder.find(params[:id])
    render layout: false
  end
  
  private
  
  def user_params
    params.require(:transcoder).permit(:host_name, :port)
  end
end
