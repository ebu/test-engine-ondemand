# Serves as a fallback for development to serve media files. Not used in production.
class MediaController < ApplicationController
  skip_before_action :require_login, only: [ :serve ]
  
  def serve
    response.headers['Access-Control-Allow-Origin'] = "*"
    response.headers['Access-Control-Allow-Methods'] = "GET, OPTIONS, HEAD"
    response.headers['Access-Control-Allow-Headers'] = "Origin, Content-Type, Accept, Range"
    
    file = [Rails.root, 'public', params[:other]].join(File::SEPARATOR)
    if File.exist?(file)
      send_file file
    else
      render plain: "Not Found", status: 404
    end
  end
end
