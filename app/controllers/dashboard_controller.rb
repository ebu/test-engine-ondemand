class DashboardController < PlugitController
  before_filter :require_login
  
  def index
    @encoding_jobs = EncodingJob.recently_encoded
    @reference_encoding_jobs = EncodingJob.referenced_for_dashboard
  end
end
