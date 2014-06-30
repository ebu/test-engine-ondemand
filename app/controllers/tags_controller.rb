class TagsController < PlugitController
  before_filter :require_admin

  def index
    @encoding_job_device_playout_tags = Tag.encoding_job_device_playout
    @encoding_job_specification_tags  = Tag.encoding_job_specification
    @preset_template_tags             = Tag.preset_template
  end
  
  def create
    tags = params[:tags].split(',')
    ids = tags.map { |tag| Tag.find_or_initialize_by(name: tag, tag_type: params[:tag_type].to_i) }
    # Create or update tags
    ids.each do |t|
      unless t.save
        render :internal_server_error, nothing: true and return
      end
    end
    
    # Delete any tags not in the input
    if tags.any?
      Tag.where("tag_type = ? AND id NOT IN (?)", params[:tag_type], ids).destroy_all
    else
      Tag.where("tag_type = ?", params[:tag_type]).destroy_all
    end
    
    render :ok, nothing: true
  end
end
