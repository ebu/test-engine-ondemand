class CodemNotification < ActiveRecord::Base
  belongs_to :variant_job, primary_key: :codem_id, foreign_key: :codem_id
  
  # Initialize a new +CodemNotification+ from a request.
  #
  # This generate a new instance where the parameters are filled
  # using the headers and params from the request.
  def self.initialize_from_request(request)
    CodemNotification.new(
      codem_id: request.params["id"],
      status: request.params["status"],
      message: request.params["message"],
      notified_at: request.headers['HTTP_X_CODEM_NOTIFY_TIMESTAMP'].to_i / 1000.0,
    )
  end
  
  # Check if this notification is one of the accept states of a +VariantJob+.
  def finished?
    ['success', 'failed'].include? status
  end
  
  # Check if this notification is a +success+ notification.
  def success?
    status == 'success'
  end
  
  # Check if this notification is a +failed+ notification.
  def failed?
    status == 'failed'
  end
end
