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
  
  def human_readable_summary_for(job)
    case job.status
    when 'pending'
      "This job is waiting to be processed."
    when 'transcoding'
      "This job is currently transcoding."
    when 'post_processing'
      "This job is currently being post-processed."
    when 'conformance_checking'
      "This job is currently being checked for DASH conformance."
    when 'success'
      "This job completed succesfully."
    when 'failed'
      "This job failed processing. Please see individual transcode jobs and/or post-processing to determine the cause."
    else
      "unknown"
    end
  end
  
  def variant_jobs_summary_for(job)
    if job.variant_jobs.any? { |v| v.failed? }
      'One or more variant jobs failed transcoding.'
    elsif job.variant_jobs.all? { |v| v.success? }
      'All variant jobs completed transcoding succesfully.'
    else
      'Waiting for jobs to finish transcoding...'
    end
  end
  
  def panel_class_for(job)
    case job.status
      when 'success' then 'panel-success'
      when 'failed' then 'panel-danger'
      else 'panel-info'
    end
  end
  
  def panel_class_for_variant_jobs(job)
    if job.variant_jobs.any? { |v| v.failed? }
      'panel-danger'
    elsif job.variant_jobs.all? { |v| v.success? }
      'panel-success'
    elsif job.transcoding?
      'panel-info'
    else
      'panel-default'
    end
  end

  def panel_class_for_post_processing(job)
    if job.completed_post_processing?
      'panel-success'
    elsif job.failed_post_processing?
      'panel-danger'
    elsif job.post_processing?
      'panel-info'
    else
      'panel-default'
    end
  end

  def panel_class_for_conformance_checking(job)
    if job.completed_conformance_checking?
      'panel-success'
    elsif job.failed_conformance_checking?
      'panel-warning'
    elsif job.post_processing?
      'panel-info'
    else
      'panel-default'
    end
  end
  
  def job_status_label(job)
    text = job.status.titleize
    case job.status
    when 'success'
      content_tag :span, text, class: "label label-success"
    when 'failed' then
      content_tag :span, text, class: "label label-danger"
    else
      content_tag :span, text, class: "label label-info"
    end
  end
end
