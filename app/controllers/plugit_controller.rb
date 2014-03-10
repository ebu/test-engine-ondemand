class PlugitController < ApplicationController
  before_filter :assign_ebu_variables
  before_filter :assign_base_uri
  before_filter :update_user
  
  # Disable *all* authenticity_token checking, because we are in reverse
  # proxy mode behind PlugIt.
  skip_before_action :verify_authenticity_token 
  
  layout('plugit') if Rails.env.development?
  layout('application') unless Rails.env.development?
  
  def is_admin?
    logged_in? && @plugit_env["HTTP_X_PLUGIT_USER_EBUIO_ADMIN"] && @plugit_env["HTTP_X_PLUGIT_USER_EBUIO_ADMIN"] == true
  end
  
  protected
  
  def logged_in_user_id
    @plugit_env["HTTP_X_PLUGIT_USER_ID"].to_i
  end
  
  def require_login
    unless logged_in?
      @plugit_message = "You need to log in to view this page."
      render template: "plugit/error"
    end
  end

  def require_admin
    unless is_admin?
      @plugit_message = "You need to be an administrator to view this page."
      render template: "plugit/error"
    end
  end
  
  def logged_in?
    !@plugit_env["HTTP_X_PLUGIT_USER_USERNAME"].blank? && !@plugit_env["HTTP_X_PLUGIT_USER_ID"].blank?
  end
  
  private
  
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
  
  def update_user
    u = User.find_or_initialize_by(ebu_id: @plugit_env["HTTP_X_PLUGIT_USER_ID"].to_i)
    u.first_name        = @plugit_env["HTTP_X_PLUGIT_USER_FIRST_NAME"]
    u.last_name         = @plugit_env["HTTP_X_PLUGIT_USER_LAST_NAME"]
    u.username          = @plugit_env["HTTP_X_PLUGIT_USER_USERNAME"]
    u.organisation_name = @plugit_env["HTTP_X_PLUGIT_ORGA_NAME"]
    u.organisation_id   = @plugit_env["HTTP_X_PLUGIT_ORGA_PK"].to_i
    u.save
  end
end