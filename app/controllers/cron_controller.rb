# Controller containing periodic actions that can be called from cron.
class CronController < ApplicationController
  # Transition all jobs if needed.
  def job_state
    EncodingJob.transition
    render :ok, nothing: true
  end

  # 
  def purge
    EncodingJob.purge!
    FileAsset.purge!
    render :ok, nothing: true
  end
end
