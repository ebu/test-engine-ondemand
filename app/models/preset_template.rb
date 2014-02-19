class PresetTemplate < ActiveRecord::Base
  enum preset_type: [ :encoder_preset, :post_processing_preset ]
  
  HUMAN_READABLE_PRESET_TYPES = [ 'Encoder preset (ffmpeg)', 'Post-processing preset (MP4Box)' ].freeze
  
  validates :preset_type, presence: true
  validates :template_text, presence: true
end
