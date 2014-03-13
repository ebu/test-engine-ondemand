class EncodingJobsController < PlugitController
  before_filter :require_login, only: [ :index, :show, :status, :play ]
  before_filter :require_write_access, only: [ :new, :create, :destroy ]
  
  def index
    @encoding_jobs = EncodingJob.where(user_id: logged_in_user.ebu_id)
  end
  
  def show
    @encoding_job = EncodingJob.find(params[:id])
  end
  
  def new
    @encoding_job = EncodingJob.new
  end
  
  def create
    @encoding_job = EncodingJob.new(user_params)
    @encoding_job.user_id = logged_in_user_id
    if @encoding_job.save
      flash[:notice] = 'Created new encoding job'
      redirect_to encoding_jobs_path
    else
      flash[:warn] = "Unable to save encoding job. #{@encoding_job.errors.messages}"
      render :new
    end
  end
  
  def destroy
    @encoding_job = EncodingJob.find(params[:id])
    if @encoding_job.user_id == logged_in_user.ebu_id && @encoding_job.destroy
      flash[:notice] = 'Encoding job removed'
    else
      flash[:warn] = "Unable to remove encoding job."
    end  
    redirect_to encoding_jobs_path
  end
  
  def status
    response.headers["EbuIo-PlugIt-NoTemplate"] = ''
    @encoding_job = EncodingJob.find(params[:id])
    render layout: false
  end
  
  def play
    @encoding_job = EncodingJob.find(params[:id])
    render layout: 'player'
  end
  
  private
  
  def user_params
    params.require(:encoding_job).permit(
      :description,
      :post_processing_template_id,
      :post_processing_flags,
      :user_id,
      variant_jobs_attributes: [ :encoder_preset_template_id, :encoder_flags, :source_file_id ])
  end
end
