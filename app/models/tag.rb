class Tag < ActiveRecord::Base
  # Tags can be applied to either encoding_jobs or preset_templates
  enum tag_type: [ :encoding_job, :preset_template ]
  
  # Tags must have a unique name within a certain tag_type
  validates :name, uniqueness: { scope: :tag_type }, presence: true
  validates :tag_type, presence: true
end
