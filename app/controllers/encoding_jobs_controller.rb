class EncodingJobsController < ApplicationController
  def index
    @encoding_jobs = EncodingJob.all
  end
  
  def new
    @encoding_job = EncodingJob.new
  end
  
  def create
    @encoding_job = EncodingJob.new(user_params)
    if @encoding_job.save
      flash[:notice] = 'Created new encoding job'
      redirect_to encoding_jobs_path
    else
      flash[:warn] = "Unable to save encoding job. #{@encoding_job.errors.messages}"
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:encoding_job).permit(
      :description,
      :post_processing_template_id,
      :post_processing_flags,
      variant_jobs_attributes: [ :encoder_preset_template_id, :encoder_flags, :source_file_id ])
  end
end
