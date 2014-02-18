class Transcoder < ActiveRecord::Base
  validates :host_name, presence: true
  validates :port, presence: true, numericality: true
  
  def available?
    @available ||= begin
      response = RestClient::Request.execute(:method => :get, :url => build_jobs_url, :timeout => 5, :open_timeout => 5)
      response.code == 200 ? true : false
    rescue Timeout::Error => e
      false
    rescue => e
      false
    end
  end
  
  private
  
  def build_jobs_url
    "http://#{host_name}:#{port}/jobs"
  end
end
