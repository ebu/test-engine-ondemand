class VariantJob < ActiveRecord::Base
  belongs_to :encoding_job
  belongs_to :encoder_preset_template, class_name: "PresetTemplate"
  belongs_to :source_file, class_name: "FileAsset"
  
  validates :encoder_flags, presence: true
  validates :source_file_path, presence: true
end
