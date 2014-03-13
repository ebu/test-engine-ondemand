class FileAsset < ActiveRecord::Base
  include Referencable
  include Expirable
  include Owned
  
  has_attached_file :resource
  
  delegate :path, to: :resource
  
  has_many :variant_jobs, foreign_key: 'source_file_id', dependent: :nullify
  
  validates_attachment :resource,
    presence: true,
    size: { in: 0..EBU::UPLOAD_MAX_SIZE }
    #content_type: { content_type: EBU::ALLOWED_CONTENT_TYPES }
end
