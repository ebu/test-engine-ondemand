module EncodingJob::Statuses
  extend ActiveSupport::Concern
  
  included do
    enum status: [ :pending, :transcoding, :post_processing, :conformance_checking, :success, :failed ]
    
    scope :eligible_jobs, -> { where(status: [
      statuses[:pending],
      statuses[:transcoding],
      statuses[:post_processing],
      statuses[:conformance_checking]
    ]) }
  end
  
  module ClassMethods
    def transition
      eligible_jobs.each { |j| j.transition }
    end
  end
  
  def transition
    self.send("transition_from_#{status}")
  end
  
  private
  
  # State machine definition, this describes all possible transitions
  def transition_from_pending
    puts "from pending"
    if requires_transcoding?
      enter_transcoding
    elsif requires_post_processing?
      enter_post_processing
    else
      enter_conformance_checking
    end
  end
  
  def transition_from_transcoding
    puts "from transcoding"
    if did_complete_transcoding?
      enter_pending
    elsif did_fail_transcoding?
      enter_failed
    end
  end
  
  def transition_from_post_processing
    puts "from post processing"
    if did_complete_post_processing?
      enter_pending
    elsif did_fail_post_processing?
      enter_failed
    end
  end
  
  def transition_from_conformance_checking
    puts "from conformance checking"
    if did_finish_conformance_checking?
      enter_success
    end
  end
  
  # Status checking methods, used to determine preconditions for transitions
  def requires_transcoding?
  end

  def requires_post_processing?
  end

  def did_complete_transcoding?
  end
  
  def did_fail_transcoding?
  end
  
  def did_complete_post_processing?
  end
  
  def did_fail_post_processing?
  end
  
  def did_finish_conformance_checking?
  end
  
  # Entering a state triggers these actions
  def enter_pending
  end

  def enter_transcoding
  end
  
  def enter_post_processing
  end
  
  def enter_conformance_checking
  end
  
  def enter_failed
  end
  
  def enter_success
  end
end