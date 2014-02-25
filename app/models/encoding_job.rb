class EncodingJob < ActiveRecord::Base
  include EncodingJob::Statuses
  
  has_many :variant_jobs, dependent: :destroy
  
  belongs_to :post_processing_job, class_name: "RemoteJob", dependent: :destroy
  belongs_to :conformance_checking_job, class_name: "RemoteJob", dependent: :destroy
  
  belongs_to :post_processing_template, class_name: "PresetTemplate"
  
  validates :post_processing_flags, presence: true

  accepts_nested_attributes_for :variant_jobs
  
  # Check if it's currently allowed to create a new +EncodingJob+.
  #
  # A new +EncodingJob+ requires at least the availability of a
  # +FileAsset+, a +PresetTemplate+ for the encoder and a +PresetTemplate+
  # for the post processor.
  def self.new_allowed?
    FileAsset.any? && PresetTemplate.encoder_preset.any? && PresetTemplate.post_processing_preset.any?
  end
  
  # Check if post-processing completed succesfully.
  def completed_post_processing?
    did_complete_post_processing?
  end
  
  # Check if post-processing failed.
  def failed_post_processing?
    did_fail_post_processing?
  end
  
  # Check if conformance checking completed succesfully.
  def completed_conformance_checking?
    did_complete_conformance_checking?
  end
  
  # Check if conformance checking failed.
  def failed_conformance_checking?
    did_fail_conformance_checking?
  end
end
