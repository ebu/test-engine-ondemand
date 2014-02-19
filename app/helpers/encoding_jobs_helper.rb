module EncodingJobsHelper
  def post_processing_templates_for_select
    PresetTemplate.post_processing_preset.map { |p| [p.description, p.id] }
  end
end
