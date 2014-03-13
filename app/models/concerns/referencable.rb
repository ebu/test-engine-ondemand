module Referencable
  extend ActiveSupport::Concern
  
  included do
    # scopes, class thingies
    validates :is_reference, inclusion: [true, false]

    scope :referenced, -> { where(is_reference: true) }
    scope :not_referenced, -> { where(is_reference: false) }
  end
  
  module ClassMethods
    # class methods
  end

  # instance methods
end