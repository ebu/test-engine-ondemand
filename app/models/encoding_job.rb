class EncodingJob < ActiveRecord::Base
  include EncodingJob::Statuses
  
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
  
  before_destroy :verify_destroy
  after_destroy :remove_output_files
  
  # Check if it's currently allowed to create a new +EncodingJob+.
  #
  # A new +EncodingJob+ requires at least the availability of a
  # +FileAsset+, a +PresetTemplate+ for the encoder and a +PresetTemplate+
  # for the post processor.
  def self.new_allowed?
    FileAsset.any? && PresetTemplate.encoder_preset.any? && PresetTemplate.post_processing_preset.any?
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
end
