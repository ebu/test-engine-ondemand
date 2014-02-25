class CodemNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create ]
  
  def create
    if codem_notification = CodemNotification.initialize_from_request(request)
      codem_notification.save
    end
    render plain: 'ok'
  end
end
