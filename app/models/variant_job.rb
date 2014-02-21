class VariantJob < ActiveRecord::Base
  belongs_to :encoding_job
  belongs_to :encoder_preset_template, class_name: "PresetTemplate"
  belongs_to :source_file, class_name: "FileAsset"
  
  has_many :codem_notifications, dependent: :destroy
  
  validates :encoder_flags, presence: true
  validates :source_file_path, presence: true
  
  before_validation(on: :create) do
    self.source_file_path = (self.source_file ? self.source_file.path : nil)
  end
end
