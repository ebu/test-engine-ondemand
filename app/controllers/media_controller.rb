class MediaController < ApplicationController
  def serve
    file = [Rails.root, 'public', params[:other]].join(File::SEPARATOR)
    if File.exist?(file)
      send_file file
    else
      render plain: "Not Found", status: 404
    end
  end
end
