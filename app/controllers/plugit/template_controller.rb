class Plugit::TemplateController < ApplicationController
  layout :false
  
  def index
    @encoding_jobs =  EncodingJob.recently_encoded
  end
end
