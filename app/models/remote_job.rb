class RemoteJob < ActiveRecord::Base
  class << self
    def initialize_for_post_processing(job)
      new({
        command: 'MP4Box',
        arguments:
          "#{job.post_processing_flags} \
          -out #{job.output_destination} \
          #{job.variant_jobs.collect(&:destination_file_path).join(' ')}"
      })
    end
    
    def initialize_for_conformance_checking(job)
      new({
        command: 'ant',
        arguments: "run -f #{EBU::CONFORMANCE_ANT_BUILD_FILE} -Dinput=#{job.output_destination}"
      })
    end
    
    def send_job(job)
      begin
        response = RestClient::Request.execute(
          method: :post,
          url: EBU::HTTP_RUNNER_HOST,
          payload: job.to_runner_json,
          timeout: EBU::NETWORK_TIMEOUT,
          open_timeout: EBU::NETWORK_TIMEOUT
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
  
  def stdout_contains_exceptions?
    stdout =~ /Exception/
  end
  
  def to_runner_json
    {
      "command" => self.command,
      "args" => self.arguments,
      "callback" => EBU::CALLBACK_URL_FOR_HTTP_RUNNER
    }.to_json
  end
end
