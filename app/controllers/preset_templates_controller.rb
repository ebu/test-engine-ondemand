class PresetTemplatesController < ApplicationController
  def index
    @encoder_presets = PresetTemplate.owned(logged_in_user).encoder_preset
    @post_processing_presets = PresetTemplate.owned(logged_in_user).post_processing_preset
    @referenced_preset_templates = PresetTemplate.referenced
  end
  
  def new
    @preset_template = PresetTemplate.new
  end
  
  def create
    @preset_template = PresetTemplate.new(user_params)
    @preset_template.user_id = logged_in_user_id
    @preset_template.tags = @preset_template.tags.uniq.reject { |t| t.blank? }
    
    if @preset_template.save
      flash[:notice] = "Preset template created."
      redirect_to preset_templates_path
    else
      flash[:alert] = "Unable to create preset template."
      render :new
    end
  end
  
  def destroy
    @preset_template = PresetTemplate.find(params[:id])
    if @preset_template.can_be_destroyed_by?(logged_in_user, is_admin?) && @preset_template.destroy
      flash[:notice] = "Preset template removed."
    else
      flash[:alert] = "Unable to remove preset template."
    end
    redirect_to preset_templates_path
  end
  
  private
  
  def user_params
    params.require(:preset_template).permit(:preset_type, :template_text, :description, :user_id, tags: [])
  end
end
