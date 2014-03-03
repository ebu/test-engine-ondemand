class Plugit::MetaController < ApplicationController
  before_filter :disable_plugit_cache
  
  def index
  end
  
  private
  
  def disable_plugit_cache
    response.headers["Expire"] = Time.now.httpdate
  end
end
