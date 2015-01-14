class TagsController < ApplicationController
  def create
    tags = params[:tags].split(',').map { |t| t.strip }
    objs = tags.map { |tag| Tag.find_or_initialize_by(name: tag) }
    # Create or update tags
    objs.each do |t|
      unless t.save
        render :internal_server_error, nothing: true and return
      end
    end
    
    render :ok, nothing: true
  end
end
