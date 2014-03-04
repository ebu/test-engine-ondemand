class Plugit::TemplateController < ApplicationController
  layout :false
  
  def index
    @encoding_jobs =  EncodingJob.recently_encoded
  end
  
  def play
    @encoding_job = EncodingJob.find(params[:id])
  end
end
