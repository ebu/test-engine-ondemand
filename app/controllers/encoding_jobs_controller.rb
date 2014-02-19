class EncodingJobsController < ApplicationController
  def index
    @encoding_jobs = EncodingJob.all
  end
  
  def new
    @encoding_job = EncodingJob.new
  end
end
