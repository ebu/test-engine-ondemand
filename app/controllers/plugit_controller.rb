class PlugitController < ApplicationController
  before_filter :assign_ebu_variables
  before_filter :assign_base_uri
  #before_filter :set_asset_prefix
  
  layout 'plugit'
  
  protected
  
  def require_login
    unless logged_in?
      @plugit_message = "You need to log in to view this page."
      render template: "plugit/error"
    end
  end
  
  def logged_in?
    !@plugit_env["HTTP_X_PLUGIT_USER_USERNAME"].blank? && !@plugit_env["HTTP_X_PLUGIT_USER_ID"].blank?
  end
  
  private
  
  # def set_asset_prefix
  #   Rails.application.config.assets.prefix = "#{assign_base_uri}media"
  # end
  
  def assign_base_uri
    @plugit_base_uri ||= @plugit_env["HTTP_X_PLUGIT_BASE_URL"] || ''
  end
  
  def assign_ebu_variables
    ebu_headers = Hash.new.tap do |h|
      request.headers.map { |k, v| k.start_with?('HTTP_X_PLUGIT_') ? h[k] = parse_value(v) : nil }
    end
    @plugit_env = ebu_headers    
  end
  
  def parse_value(value)
    if ["True", "False"].include?(value)
      value == "True" ? true : false
    else
      value
    end
  end
end