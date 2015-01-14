# Encoding Jobs controller. Handles all actions related to encoding jobs.
class EncodingJobsController < ApplicationController
  # Only a login is required for the read-only actions index, show, status and play.
  before_filter :require_login, only: [ :index, :show, :status, :play, :new, :create, :destroy, :reference_presets, :unreference_presets,
                                        :reference, :unreference, :reference_source_files, :unreference_source_files ]
  # Assign the job for specific actions
  before_filter :assign_job, only: [ :show, :destroy, :status, :play, :reference_presets, :unreference_presets,
                                     :reference, :unreference, :reference_source_files, :unreference_source_files ]
  
  # Index action shows own jobs and reference jobs.
  def index
    @encoding_jobs = EncodingJob.owned(logged_in_user).order("created_at DESC")
    @referenced_encoding_jobs = EncodingJob.referenced_for_dashboard
  end
  
  # Show a specific job.
  def show
  end
  
  # Show the "new encoding job" form.
  def new
    @encoding_job = EncodingJob.new
  end
  
  # Create a new encoding job belonging to the logged in user.
  def create
    @encoding_job = EncodingJob.new(user_params)
    @encoding_job.user = logged_in_user
    @encoding_job.device_playout_tags = @encoding_job.device_playout_tags.uniq.reject { |t| t.blank? }
    @encoding_job.specification_tags = @encoding_job.specification_tags.uniq.reject { |t| t.blank? }
    
    if @encoding_job.save
      flash[:notice] = 'Created new encoding job'
      redirect_to encoding_jobs_path
    else
      flash[:warn] = "Unable to save encoding job. Make sure to fill in all the fields. #{@encoding_job.errors.messages}"
      render :new
    end
  end
  
  # Destroy the specified encoding job.
  def destroy
    if @encoding_job.can_be_destroyed_by?(logged_in_user) && @encoding_job.destroy
      flash[:notice] = 'Encoding job removed'
    else
      flash[:warn] = "Unable to remove encoding job."
    end  
    redirect_to encoding_jobs_path
  end
  
  # Render a partial HTML response with the status of the job.
  def status
    render layout: false
  end
  
  # Show the Dash.js player for a specific job.
  def play
    render layout: 'player'
  end
  
  # Reference presets for this job
  def reference_presets
    set_reference_presets(@encoding_job, true)
    redirect_to play_encoding_job_path(@encoding_job)
  end

  # Unreference presets for this job
  def unreference_presets
    set_reference_presets(@encoding_job, false)
    redirect_to play_encoding_job_path(@encoding_job)
  end
  
  # Reference this encoding job
  def reference
    @encoding_job.update_attribute(:is_reference, true)
    redirect_to play_encoding_job_path(@encoding_job)
  end
  
  # Unreference this encoding job
  def unreference
    @encoding_job.update_attribute(:is_reference, false)
    redirect_to play_encoding_job_path(@encoding_job)
  end
  
  # Reference the source files for this job
  def reference_source_files
    set_reference_source_file(@encoding_job, true)
    redirect_to play_encoding_job_path(@encoding_job)
  end
  
  # Unreference the source files for this job
  def unreference_source_files
    set_reference_source_file(@encoding_job, false)
    redirect_to play_encoding_job_path(@encoding_job)
  end
  
  private
  
  # Find the specified job and assign it.
  def assign_job
    @encoding_job = EncodingJob.find(params[:id])
  end
  
  # Process all preset templates from the variant jobs and update their reference status.
  def set_reference_presets(job, value)
    job.post_processing_template.update_attribute(:is_reference, value) if job.post_processing_template
    job.variant_jobs.each do |v|
      v.encoder_preset_template.update_attribute(:is_reference, value) if v.encoder_preset_template
    end
  end

  # Process all source files for this job and update their reference status.
  def set_reference_source_file(job, value)
    job.variant_jobs.each do |v|
      v.source_file.update_attribute(:is_reference, value) if v.source_file
    end
  end
  
  # Allow setting specific attributes when creating a new job.
  def user_params
    params.require(:encoding_job).permit(
      :description,
      :post_processing_template_id,
      :post_processing_flags,
      variant_jobs_attributes: [ :encoder_preset_template_id, :encoder_flags, :source_file_id ],
      device_playout_tags: [],
      specification_tags: [])
  end
end
