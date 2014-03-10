class FileAsset < ActiveRecord::Base
  has_attached_file :resource
  
  delegate :path, to: :resource
  
  has_many :variant_jobs, foreign_key: 'source_file_id', dependent: :nullify
  
  belongs_to :user, primary_key: 'ebu_id', foreign_key: 'user_id'
  
  validates_attachment :resource,
    presence: true,
    size: { in: 0..EBU::UPLOAD_MAX_SIZE }
    #content_type: { content_type: EBU::ALLOWED_CONTENT_TYPES }
  
  validates :user_id, presence: true
end
