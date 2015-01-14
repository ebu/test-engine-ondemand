module EncodingJobsHelper
  def encoder_templates_for_select
    user = controller.logged_in_user
    PresetTemplate.encoder_preset.owned_or_referenced(user).map { |p| [p.description, p.id, {'data-preset' => p.template_text}] }
  end

  def post_processing_templates_for_select
    user = controller.logged_in_user
    PresetTemplate.post_processing_preset.owned_or_referenced(user).map { |p| [p.description, p.id, {'data-preset' => p.template_text}] }
  end
  
  def source_files_for_select
    user = controller.logged_in_user
    FileAsset.owned_or_referenced(user).map { |f| [f.resource_file_name, f.id] }
  end
  
  # Check if it's currently allowed to create a new +EncodingJob+.
  #
  # A new +EncodingJob+ requires at least the availability of a
  # +FileAsset+, a +PresetTemplate+ for the encoder and a +PresetTemplate+
  # for the post processor.
  def encoding_job_new_allowed?
    user = controller.logged_in_user
    FileAsset.owned_or_referenced(user).any? &&
    PresetTemplate.owned_or_referenced(user).encoder_preset.any? &&
    PresetTemplate.owned_or_referenced(user).post_processing_preset.any?
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
  
  def post_processing_summary_for(job)
    if job.post_processing?
      'Waiting for post-processing to complete...'
    elsif job.failed_post_processing?
      collapsable_group('An error occurred during post-processing.', 'post_processing_details', job.post_processing_job.stderr)
    elsif job.completed_post_processing?
      collapsable_group('Post-processing finished successfully.', 'post_processing_details', job.post_processing_job.stderr)
    else
      'Information not yet available.'
    end
  end
  
  def conformance_checking_summary_for(job)
    if job.conformance_checking?
      'Waiting for conformance-checking to complete...'
    elsif job.failed_conformance_checking?
      collapsable_group('An error occurred during conformance-checking.', 'conformance_checking_details', job.conformance_checking_job.stdout)
    elsif job.completed_conformance_checking?
      if job.conformance_checking_job.stdout_contains_exceptions?
        collapsable_group('Conformance-checking finished, but may contain errors. Please check details.', 'conformance_checking_details', job.conformance_checking_job.stdout)
      else
        collapsable_group('Conformance-checking finished successfully.', 'conformance_checking_details', job.conformance_checking_job.stdout)
      end
    else
      'Information not yet available.'
    end
  end
  
  def collapsable_group(text, id, data)
    ("<div class='collapse-group'>#{text}" +
    "<a style='float: right' class='btn btn-default' data-toggle='collapse' data-target='##{id}'>View/hide details</a>" +
    "<pre class='collapse' id='#{id}'>" + data + "</pre></div>").html_safe
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
      job.conformance_checking_job.stdout_contains_exceptions? ? 'panel-warning' : 'panel-success'
    elsif job.failed_conformance_checking?
      'panel-danger'
    elsif job.conformance_checking?
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
  
  def play_link(job)
    link_to('Open in Dash.js player', play_encoding_job_path(job), class: 'btn btn-primary')
  end

  def raw_mpd_url(job)
    (root_url + job.mpd_url).gsub('//','/')
  end
  
  def queue_position_for(variant_job)
    pos = VariantJob.queue_position_for(variant_job)
    (pos.nil?) ? '' : "Queued (#{pos + 1})"
  end
  
  def availability_label_for_template(template)
    if template.blank?
      content_tag :span, 'not available', class: "label label-danger", title: "This template is no longer available to make a reference. It might have been deleted."
    else
      content_tag :span, 'available', class: "label label-success", title: "This template is still available to make a reference."
    end
  end
end
