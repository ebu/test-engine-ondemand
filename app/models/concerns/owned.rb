module Owned
  extend ActiveSupport::Concern
  
  included do
    # scopes, class thingies
    validates :user_id, presence: true
    
    belongs_to :user, primary_key: 'ebu_id', foreign_key: 'user_id'
  end
  
  module ClassMethods
    # class methods
  end

  # instance methods
end