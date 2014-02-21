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
    if requires_transcoding?
      enter_transcoding
    elsif requires_post_processing?
      enter_post_processing
    else
      enter_conformance_checking
    end
  end
  
  def transition_from_transcoding
    if did_complete_transcoding?
      enter_pending
    elsif did_fail_transcoding?
      enter_failed
    end
  end
  
  def transition_from_post_processing
    if did_complete_post_processing?
      enter_pending
    elsif did_fail_post_processing?
      enter_failed
    end
  end
  
  def transition_from_conformance_checking
    if did_finish_conformance_checking?
      enter_success
    end
  end
  
  # Status checking methods, used to determine preconditions for transitions
  def requires_transcoding?
    variant_jobs.all? { |j| j.requires_transcoding? }
  end

  # Return true if all variants finished trancoding succesfully. False otherwise.
  def did_complete_transcoding?
    if variant_jobs.all? { |j| j.finished? }
      variant_jobs.any? { |j| j.failed? } ? false : true
    else
      false
    end
  end
  
  # Return true if all variants finished transcoding and at least one failed. False otherwise.
  def did_fail_transcoding?
    if variant_jobs.all? { |j| j.finished? }
      variant_jobs.any? { |j| j.failed? } ? true : false
    else
      false
    end
  end
  
  def requires_post_processing?
    true
  end

  def did_complete_post_processing?
    false
  end
  
  def did_fail_post_processing?
    false
  end
  
  def did_finish_conformance_checking?
    false
  end
  
  # Entering a state triggers these actions
  def enter_pending
    update_attribute(:status, :pending)
  end

  def enter_transcoding
    # Send variant jobs to codem
    update_attribute(:status, :transcoding)
  end
  
  def enter_post_processing
    # Launch MP4Box for packaging/DASHing
    update_attribute(:status, :post_processing)
  end
  
  def enter_conformance_checking
    # Launch conformance checking tools
    update_attribute(:status, :conformance_checking)
  end
  
  def enter_failed
    update_attribute(:status, :failed)
  end
  
  def enter_success
    update_attribute(:status, :success)
  end
end