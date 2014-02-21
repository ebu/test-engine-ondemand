class EncodingJob < ActiveRecord::Base
  include EncodingJob::Statuses
  
  has_many :variant_jobs, dependent: :destroy
  
  belongs_to :post_processing_template, class_name: "PresetTemplate"
  
  validates :post_processing_flags, presence: true

  accepts_nested_attributes_for :variant_jobs
  
  def self.new_allowed?
    FileAsset.any? && PresetTemplate.encoder_preset.any? && PresetTemplate.post_processing_preset.any?
  end
end
