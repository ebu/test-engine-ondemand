class PresetTemplate < ActiveRecord::Base
  enum preset_type: [ :encoder_preset, :post_processing_preset ]
end
