class Transcoder < ActiveRecord::Base
  validates :host_name, presence: true
  validates :port, presence: true, numericality: true
  
  def available?
    begin
      response = RestClient::Request.execute(:method => :get, :url => build_jobs_url, :timeout => 5, :open_timeout => 5)
      puts response
      response.code == 200 ? true : false
    rescue Timeout::Error => e
      puts e
      false
    rescue => e
      puts e
      false
    end
  end
  
  private
  
  def build_jobs_url
    "http://#{host_name}:#{port}/jobs"
  end
end
