class FileAsset < ActiveRecord::Base
  include Referencable
  include Expirable
  include Owned
  
  has_attached_file :resource, path: EBU::UPLOAD_PATH
  
  delegate :path, to: :resource
  
  has_many :variant_jobs, foreign_key: 'source_file_id', dependent: :nullify
  
  validates :resource, attachment_size: { in: 0..EBU::UPLOAD_MAX_SIZE }, unless: :is_reference?
end
