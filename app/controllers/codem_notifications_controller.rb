# Controller receiving any notifications from the Codem transcoder.
class CodemNotificationsController < ApplicationController
  # The Codem callback does not use the authenticity token.
  skip_before_action :verify_authenticity_token, only: [ :create ]
  skip_before_action :require_login, only: [ :create ]
  
  # Create and save a new Codem notification.
  def create
    if codem_notification = CodemNotification.initialize_from_request(request)
      codem_notification.save
    end
    render plain: 'ok'
  end
end
