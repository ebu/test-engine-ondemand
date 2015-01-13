# Dashboard overview controller.
class DashboardController < ApplicationController
  # Index overview for the dashboard.
  #
  # Shows recently encoded jobs and any reference encoding jobs.
  def index
    @encoding_jobs = EncodingJob.recently_encoded
    @referenced_encoding_jobs = EncodingJob.referenced_for_dashboard
  end
end
