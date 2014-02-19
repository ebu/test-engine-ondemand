class EncodingJob < ActiveRecord::Base
  enum status: [ :pending, :transcoding, :post_processing, :conformance_checking, :success, :failed ]
  
  #has_many :variant_jobs
  belongs_to :post_processing_template, class_name: "PresetTemplate"
  
  validates :post_processing_flags, presence: true
  
  def self.new_allowed?
    FileAsset.any? && PresetTemplate.encoder_preset.any? && PresetTemplate.post_processing_preset.any?
  end
end
