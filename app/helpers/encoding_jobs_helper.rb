module EncodingJobsHelper
  def new_encoding_job_allowed?
    FileAsset.any? && PresetTemplate.encoder_preset.any? && PresetTemplate.post_processing_preset.any?
  end
end
