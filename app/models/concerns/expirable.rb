module Expirable
  extend ActiveSupport::Concern
  
  included do
    # scopes, class thingies
    scope :expired, -> { where(["created_at < ?", EBU::MAX_AGE.ago]) }
  end
  
  module ClassMethods
    # class methods
    def to_purge
      expired.not_referenced
    end
    
    def purge!
      to_purge.destroy_all
    end
  end

  # instance methods
end