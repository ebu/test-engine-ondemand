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
  
  def transition_from_pending
    puts "from pending"
  end
  
  def transition_from_transcoding
    puts "from transcoding"
  end
  
  def transition_from_post_processing
    puts "from post processing"
  end
  
  def transition_from_conformance_checking
    puts "from conformance checking"
  end
end