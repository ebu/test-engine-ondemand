class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_user
  before_filter :require_login

  private
  
  def check_user
    u = User.find_or_create_by(uid: 'anonymous')
    u.save
  end
  
  def require_login
    u = User.find_by(uid: 'anonymous')
    session['uid'] = u.uid
  end
end
