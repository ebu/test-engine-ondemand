class Transcoder < ActiveRecord::Base
  # Transcoder requires a host_name (or IP address, i.e. something that resolves)
  validates :host_name, presence: true
  # Transcoder requires a port (e.g. 8080)
  validates :port, presence: true, numericality: true
  
  # All jobs that are associated with a transcoder.
  has_many :variant_jobs, dependent: :nullify
  
  # Return all currently available transcoder hosts.
  def self.available
    all.select { |t| t.available? }.shuffle
  end
  
  # Check if this transcoder is currently available.
  def available?
    @available ||= begin
      response = RestClient::Request.execute(
        method: :get,
        url: build_jobs_url,
        timeout: EBU::TRANSCODER_TIMEOUT,
        open_timeout: EBU::TRANSCODER_TIMEOUT
      )
      response.code == 200 ? true : false
    rescue Timeout::Error => e
      false
    rescue => e
      false
    end
  end
  
  # Send a job to the transcoder.
  #
  # This will attempt to directly create a job on the transcoder. If the transcoder
  # did not accept the job it will return +nil+. Otherwise it will return the Codem
  # ID that was assigned to it.
  #
  # ==== Examples
  #  # t = Transcoder.first
  #  # t.send_job VariantJob.first
  #   => "4db5881df91da078bb7f9d9092b7c2cc26b29d58"
  def send_job(job)
    begin
      response = RestClient::Request.execute(
        method: :post,
        url: build_jobs_url,
        payload: job.to_codem_json,
        timeout: EBU::TRANSCODER_TIMEOUT,
        open_timeout: EBU::TRANSCODER_TIMEOUT
      )
      if response.code == 202
        if (obj = JSON.parse(response.to_str))
          obj["job_id"]
        else
          raise "Job #{job.id} was created on transcoder #{self.id}, but no job ID was returned."
        end
      else
        nil
      end
    rescue Timeout::Error => e
      nil
    rescue => e
      nil
    end
  end
  
  private
  
  # Build the base URL to connect to the transcoder.
  def build_jobs_url
    "http://#{host_name}:#{port}/jobs"
  end
end
