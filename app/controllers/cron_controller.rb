# Controller containing periodic actions that can be called for example from cron.
class CronController < ApplicationController
  skip_before_action :require_login, only: [ :job_state, :purge, :organizations ]
  
  # Transition all jobs if needed.
  def job_state
    EncodingJob.transition
    render :ok, nothing: true
  end

  # Purge all jobs that have expired.
  def purge
    EncodingJob.purge!
    FileAsset.purge!
    render :ok, nothing: true
  end
end
