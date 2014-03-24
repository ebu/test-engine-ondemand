# This controller provides basic PlugIt methods.
#
# The requirements for these actions are describe here:
# https://github.com/ebu/PlugIt#basic-methods
class BasicController < PlugitController
  layout false
  
  # Respond to a PlugIt ping request.
  #
  # Sends back an empty HTTP 200 response, or the 'data' parameter that was provided by PlugIt.
  def ping
    data = params[:data] || ''
    render json: { data: data }
  end
  
  # Respond with the PlugIt version number.
  def version
    render json: { result: 'Ok', version: '1', protocol: 'EBUio-PlugIt' }
  end
end
