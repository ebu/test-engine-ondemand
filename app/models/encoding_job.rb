class EncodingJob < ActiveRecord::Base
  include EncodingJobStatuses
  include Referencable
  include Expirable
  include Owned
  
  has_many :variant_jobs, dependent: :destroy
  
  belongs_to :post_processing_job, class_name: "RemoteJob", dependent: :destroy
  belongs_to :conformance_checking_job, class_name: "RemoteJob", dependent: :destroy
  
  belongs_to :post_processing_template, class_name: "PresetTemplate"
  
  validates :post_processing_flags, presence: true
  validates :description, presence: true
  
  accepts_nested_attributes_for :variant_jobs
  
  before_create do
    self.random_id = SecureRandom.hex(8)
  end
  
  scope :recently_encoded, -> { success.limit(10).order("created_at DESC") }
  scope :referenced_for_dashboard, -> { success.referenced.order("created_at DESC") }
  
  before_destroy :verify_destroy
  after_destroy :remove_output_files

  # Check if presets are still available
  def presets_available?
    !post_processing_template.blank? && variant_jobs.all? { |v| !v.encoder_preset_template.blank? }
  end
  
  # Check if presets are referenced
  def presets_referenced?
    post_processing_template.try(:is_reference?) && variant_jobs.all? { |v| v.encoder_preset_template.try(:is_reference?) }
  end
  
  def source_files_available?
    variant_jobs.all? { |v| !v.source_file.blank? }
  end

  def source_files_referenced?
    variant_jobs.all? { |v| v.source_file.try(:is_reference?) }
  end
  
  # Check if post-processing completed successfully.
  def completed_post_processing?
    did_complete_post_processing?
  end
  
  # Check if post-processing failed.
  def failed_post_processing?
    did_fail_post_processing?
  end
  
  # Check if conformance checking completed successfully.
  def completed_conformance_checking?
    did_complete_conformance_checking?
  end
  
  # Check if conformance checking failed.
  def failed_conformance_checking?
    did_fail_conformance_checking?
  end
  
  def output_destination
    (output_path << 'dash.mpd').join(File::SEPARATOR)
  end

  def randomized_id
    random_id.blank? ? id.to_s : "#{id}-#{random_id}"
  end
  
  def destroy_allowed?
    success? || failed? || initial?
  end

  # Post encoding job to EBU.io forum. Will silently fail is something goes wrong, so the
  # job will not be marked as failed.
  def post_to_forum
    begin
      response = RestClient::Request.execute(
        method: :post,
        url: EBU::API_URL + "/ebuio/forum/",
        timeout: EBU::NETWORK_TIMEOUT,
        open_timeout: EBU::NETWORK_TIMEOUT,
        headers: { 'Accept-Charset' => 'utf-8' },
        payload: {
          subject: "New encoding: #{self.description}",
          author: self.user_id.to_s,
          message: forum_message_template,
          tags: "encoding"
        }
      )
      if response.code == 200 && obj = JSON.parse(response.to_str)
        self.update_attribute(:forum_url, obj["url"])
      end
    rescue Timeout::Error => e
      nil
    rescue => e
      nil
    end
  end
  
  
  private

  def verify_destroy
    if destroy_allowed?
      true
    else
      self.errors.add(:base, "Cannot delete encoding job while it is being processed.")
      false
    end
  end
  
  def remove_output_files
    FileUtils.remove_dir output_path.join(File::SEPARATOR), force: true
  end
  
  def remove_intermediate_files
    files = variant_jobs.collect(&:destination_file_path)
    FileUtils.rm files, force: true
  end
  
  def output_path
    [EBU::FINAL_FILE_LOCATION, randomized_id]
  end
  
  # Attempt to create a post-processing job.
  #
  # Also attempts to create the output directory for the final DASHed job.
  # Returns true if successful, false otherwise.
  def create_post_processing_job
    FileUtils.mkdir_p(output_path.join(File::SEPARATOR))
    self.post_processing_job = RemoteJob.initialize_for_post_processing(self)
    self.save
  end
  
  def create_conformance_checking_job
    self.conformance_checking_job = RemoteJob.initialize_for_conformance_checking(self)
    self.save
  end
  
  def forum_message_template
    mpd_url = "#{EBU::APP_HOST}/#{Rails.application.config.ebu_plugit_local_root}/media/" + ['dash', self.randomized_id, 'dash.mpd'].join('/')
    template = "A new encoding was added to the test encoding platform using the following settings: 

* * *

### Variant Jobs

"

self.variant_jobs.each do |v|
  template << "
* **Source file**: `#{v.source_file.resource_file_name}`
* **Preset settings**: `#{v.encoder_flags}`

  "
end

template << "
### Post-processing preset

`#{self.post_processing_flags}`


[View this video in Dash.js player](http://ebu.io/#{Rails.application.config.ebu_plugit_root}/encoding_jobs/#{self.id}/play)

Raw MPD: [#{mpd_url}](#{mpd_url})"
  end
end
