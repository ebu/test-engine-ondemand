# Dashboard overview controller.
class DashboardController < ApplicationController
  # Index overview for the dashboard.
  #
  # Shows recently encoded jobs.
  def index
    @encoding_jobs = EncodingJob.recently_encoded @logged_in_user
  end
end
