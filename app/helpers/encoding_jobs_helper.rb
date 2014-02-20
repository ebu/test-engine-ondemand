module EncodingJobsHelper
  def encoder_templates_for_select
    PresetTemplate.encoder_preset.map { |p| [p.description, p.id, {'data-preset' => p.template_text}] }
  end

  def post_processing_templates_for_select
    PresetTemplate.post_processing_preset.map { |p| [p.description, p.id, {'data-preset' => p.template_text}] }
  end
  
  def source_files_for_select
    FileAsset.all.map { |f| [f.resource_file_name, f.id] }
  end
  
  def link_to_add_variant_job(name, f, parent)
    new_object = VariantJob.new
    fields = f.fields_for(:variant_jobs, new_object, :child_index => "new_variant_job") do |builder|
      render("variant_job_fields", :f => builder)
    end
    link_to(name, '#', onclick: "ebu.add_fields(this, \"#{parent}\", \"#{escape_javascript(fields)}\"); return false;", class: "small")
  end
end
