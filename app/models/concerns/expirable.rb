module Expirable
  extend ActiveSupport::Concern
  
  included do
    # scopes, class thingies
    scope :expired, -> { where(["created_at < ?", EBU::MAX_AGE.ago]) }
  end
  
  module ClassMethods
    # class methods
  end

  # instance methods
end