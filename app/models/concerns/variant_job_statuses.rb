require 'active_support/concern'

module VariantJobStatuses
  extend ActiveSupport::Concern
  
  included do
    enum status: [ :pending, :transcoding, :success, :failed ]
    
    scope :eligible_jobs, -> { where(status: [
      statuses[:pending],
      statuses[:transcoding]
    ]).order("created_at ASC") }

    scope :queued_jobs, -> { where(status: statuses[:pending]) }
  end
  
  module ClassMethods
    def transition
      eligible_jobs.each { |j| j.transition }
    end

    def queue_position_for(j)
      self.queued_jobs.index j
    end
  end
  
  def transition
    self.send("transition_from_#{status}") unless finished?
  end
  
  def finished?
    success? || failed?
  end
  
  private
  
  # State machine definition, this describes all possible transitions
  def transition_from_pending
    enter_transcoding if Transcoder.available.any?
  end
  
  def transition_from_transcoding
    current_state = codem_notifications.last
    if current_state.try(:finished?)
      enter_failed  if current_state.failed?
      enter_success if current_state.success?
    end
  end
      
  # Entering a state triggers these actions
  def enter_transcoding
    # Send variant jobs to codem
    t = Transcoder.available
    if t.any? && send_to_transcoder(t.first)
      update_attribute(:status, :transcoding)
    end
  end
  
  def enter_failed
    update_attribute(:status, :failed)
  end
  
  def enter_success
    update_attribute(:status, :success)
  end
end