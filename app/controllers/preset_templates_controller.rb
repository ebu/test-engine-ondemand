class PresetTemplatesController < PlugitController
  before_filter :require_login, only: [ :index ]
  before_filter :require_write_access, only: [ :new, :create, :destroy ]
  
  def index
    @encoder_presets = PresetTemplate.where(user_id: logged_in_user.ebu_id).encoder_preset
    @post_processing_presets = PresetTemplate.where(user_id: logged_in_user.ebu_id).post_processing_preset
  end
  
  def new
    @preset_template = PresetTemplate.new
  end
  
  def create
    @preset_template = PresetTemplate.new(user_params)
    @preset_template.user_id = logged_in_user_id
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
    if @preset_template.user_id == logged_in_user.ebu_id && @preset_template.destroy
      flash[:notice] = "Preset template removed."
    else
      flash[:alert] = "Unable to remove preset template."
    end
    redirect_to preset_templates_path
  end
  
  private
  
  def user_params
    params.require(:preset_template).permit(:preset_type, :template_text, :description, :user_id)
  end
end
