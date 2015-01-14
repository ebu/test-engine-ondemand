class User < ActiveRecord::Base
  has_many :encoding_jobs
  has_many :preset_templates
  has_many :file_assets
  
  validates :uid, presence: true
end
