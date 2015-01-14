module Auth
  extend ActiveSupport::Concern

  included do
    before_filter :check_user
    before_filter :require_login
  end
  
  private
  
  def check_user
    u = User.find_or_create_by(uid: 'anonymous')
    u.save
  end
  
  def require_login
    u = User.find_by(uid: 'anonymous')
    session['uid'] = u.uid
  end
  
  def logged_in_user
    @user ||= (session && session['uid']) ? User.find_by(uid: session['uid']) : nil
  end
end