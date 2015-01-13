# Controller managing notifications from http-runner.
class HttpRunnerNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create ]
  skip_before_action :require_login, only: [ :create ]
  
  def create
    if remote_job = RemoteJob.find_by(remote_id: params["id"])
      remote_job.update_attributes({
        stderr: params["stderr"],
        stdout: params["stdout"],
        code: params["code"]
      })
    end
    render plain: 'ok'
  end
end
