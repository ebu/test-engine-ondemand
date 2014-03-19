require 'active_support/concern'

module EncodingJobStatuses
  extend ActiveSupport::Concern
  
  included do
    enum status: [ :pending, :transcoding, :post_processing, :conformance_checking, :success, :failed ]
    
    scope :eligible_jobs, -> { where(status: [
      statuses[:pending],
      statuses[:transcoding],
      statuses[:post_processing],
      statuses[:conformance_checking]
    ]).order("created_at ASC") }
  end
  
  module ClassMethods
    def transition
      j = eligible_jobs
      if j.any?
        puts "Examining transition states for #{j.count} encoding jobs."
        j.each { |j| j.transition }
      end
    end
  end
  
  def transition
    self.send("transition_from_#{status}")
  end
  
  def initial?
    (pending? && !did_finish_transcoding? && !did_finish_post_processing? && !did_finish_conformance_checking?)
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
    else
      variant_jobs.map { |j| j.transition }
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
  
  def did_finish_transcoding?
    variant_jobs.all? { |j| j.finished? }
  end
  
  def requires_post_processing?
    post_processing_job.blank?
  end

  def did_complete_post_processing?
    !!post_processing_job.try(:completed?)
  end
  
  def did_fail_post_processing?
    !!post_processing_job.try(:failed?)
  end
  
  def did_finish_post_processing?
    did_complete_post_processing? || did_fail_post_processing?
  end
  
  def did_finish_conformance_checking?
    did_complete_conformance_checking? || did_fail_conformance_checking?
  end
  
  def did_complete_conformance_checking?
    !!conformance_checking_job.try(:completed?)
  end
  
  def did_fail_conformance_checking?
    !!conformance_checking_job.try(:failed?)
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
    if create_post_processing_job && remote_id = RemoteJob.send_job(post_processing_job)
      update_attribute(:status, :post_processing)
    end
  end
  
  def enter_conformance_checking
    # Launch conformance checking tools
    if create_conformance_checking_job && remote_id = RemoteJob.send_job(conformance_checking_job)
      update_attribute(:status, :conformance_checking)
    end
  end
  
  def enter_failed
    # TODO: Remove all intermediate files and output files
    remove_intermediate_files
    remove_output_files
    update_attribute(:status, :failed)
  end
  
  def enter_success
    # TODO: Remove all intermediate files
    remove_intermediate_files
    update_attribute(:status, :success)
  end
end