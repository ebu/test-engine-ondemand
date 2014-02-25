class EncodingJob < ActiveRecord::Base
  include EncodingJob::Statuses
  
  has_many :variant_jobs, dependent: :destroy
  
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
end
