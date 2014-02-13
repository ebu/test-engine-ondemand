class FileAsset < ActiveRecord::Base
  has_attached_file :resource
  
  validates_attachment :resource,
    presence: true,
    size: { in: 0..EBU::UPLOAD_MAX_SIZE },
    content_type: { content_type: EBU::ALLOWED_CONTENT_TYPES }
end
