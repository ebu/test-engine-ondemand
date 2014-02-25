class RemoteJob < ActiveRecord::Base
  class << self
    def initialize_for_post_processing(job)
      new({
        command: 'echo',
        arguments: job.post_processing_flags
      })
    end
    
    def initialize_for_conformance_checking(job)
      new({
        command: 'echo',
        arguments: 'foo'
      })
    end
    
    def send_job(job)
      begin
        response = RestClient::Request.execute(
          method: :post,
          url: EBU::HTTP_RUNNER_HOST,
          payload: job.to_runner_json,
          timeout: EBU::TRANSCODER_TIMEOUT,
          open_timeout: EBU::TRANSCODER_TIMEOUT
        )
        if response.code == 202
          if (obj = JSON.parse(response.to_str))
            job.update_attribute(:remote_id, obj["id"])
            obj["id"]
          else
            raise "Job #{job.id} was created, but no job ID was returned."
          end
        else
          nil
        end
      rescue Timeout::Error => e
        nil
      # rescue => e
      #   nil
      end
    end
  end
  
  def finished?
    !code.nil?
  end
  
  def completed?
    code == 0
  end
  
  def failed?
    !code.nil? && code != 0
  end
  
  def to_runner_json
    {
      "command" => self.command,
      "args" => self.arguments,
      "callback" => EBU::CALLBACK_URL_FOR_HTTP_RUNNER
    }.to_json
  end
end
