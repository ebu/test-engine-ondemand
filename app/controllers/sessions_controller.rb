class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  skip_before_filter :require_login, :only => [:create, :login]
  
  def create
    create_session request.env['omniauth.auth']
    redirect_to root_path
  end
  
  def login
    if Rails.application.config.perform_omniauth_authentication
      redirect_to "/auth/#{Rails.application.config.omniauth_strategy_url}"
    else
      create_session
      redirect_to root_path
    end
  end
  
  private
  
  def create_session(user_info={})
    if user_info['uid']
      session['uid'] = User.find_or_create(uid: user_info['uid'])
    elsif !Rails.application.config.perform_omniauth_authentication
      session['uid'] = User.find_or_create(uid: 'anonymous')
    end
  end
end
