class VariantJob < ActiveRecord::Base
  include VariantJobStatuses

  belongs_to :encoding_job
  belongs_to :encoder_preset_template, class_name: "PresetTemplate"
  belongs_to :source_file, class_name: "FileAsset"
  belongs_to :transcoder
  
  # Order notifications by the transcoder timestamp +notified_at+ and
  # the status.
  #
  # In the unlikely condition that two notifications were received
  # on the same millisecond prefer the highest status, because they
  # indicate the accept states.
  has_many :codem_notifications, -> { order("notified_at ASC, status ASC") }, primary_key: :codem_id, foreign_key: :codem_id, dependent: :destroy
  
  validates :encoder_flags, presence: true
  validates :source_file_path, presence: true
  validates :destination_file_path, presence: true
  
  before_validation(on: :create) do
    self.source_file_path      = (self.source_file ? self.source_file.path : nil)
    self.destination_file_path = [EBU::INTERMEDIATE_FILE_LOCATION, SecureRandom.hex(40)].join(File::SEPARATOR)
  end
  
  def requires_transcoding?
    codem_id.blank?
  end
  
  def progress
    @progress ||= if success?
      1.0
    elsif (failed? || pending?)
      0.0
    elsif transcoder
      transcoder.get_progress(self)
    else
      0.0
    end
  end
  
  # Return a presentation of a job that is suited to present to
  # the codem transcoder.
  #
  # See https://github.com/madebyhiro/codem-transcode/blob/master/README.markdown
  def to_codem_json
    {
      "source_file"      => source_file_path,
      "destination_file" => destination_file_path,
      "encoder_options"  => encoder_flags,
      "callback_urls"    => [ EBU::CALLBACK_URL_FOR_CODEM ]
    }.to_json
  end
  
  private

  def send_to_transcoder(t)
    if codem_id = t.send_job(self)
      update({ codem_id: codem_id, transcoder: t })
    else
      false
    end
  end
end
