class User < ActiveRecord::Base
  has_many :encoding_jobs, foreign_key: 'user_id', primary_key: 'ebu_id'
  has_many :preset_templates, foreign_key: 'user_id', primary_key: 'ebu_id'
  has_many :file_assets, foreign_key: 'user_id', primary_key: 'ebu_id'
  
  validates :uid, presence: true
end
