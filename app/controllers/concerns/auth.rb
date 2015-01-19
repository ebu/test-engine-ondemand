module Auth
  extend ActiveSupport::Concern

  included do
    before_filter :assign_user
    before_filter :require_login
  end

  def assign_user
    @logged_in_user ||= (session && session['uid']) ? User.find_by(uid: session['uid']) : nil
  end
  
  private
  
  def require_login
    redirect_to '/login' unless @logged_in_user
  end
end