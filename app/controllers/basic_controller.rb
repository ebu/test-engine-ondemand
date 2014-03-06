# This controller provides basic PlugIt methods.
#
# The requirements for these actions are describe here:
# https://github.com/ebu/PlugIt#basic-methods
class BasicController < PlugitController
  layout false
  
  def ping
    data = params[:data] || ''
    render json: { data: data }
  end
  
  def version
    render json: { result: 'Ok', version: '1', protocol: 'EBUio-PlugIt' }
  end
end
