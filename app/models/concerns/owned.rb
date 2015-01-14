module Owned
  extend ActiveSupport::Concern
  
  included do
    # scopes, class thingies
    validates :user_id, presence: true
    
    belongs_to :user
  end
  
  module ClassMethods
    # class methods
    def owned(user)
      where(user_id: user.id)
    end
    
    def owned_or_referenced(user)
      where(["user_id = ? OR is_reference = ?", user.id, true])
    end
  end

  # instance methods
  def owned_by?(user)
    self.user == user
  end
  
  def can_be_destroyed_by?(user)
    self.owned_by?(user) && !self.is_reference?
  end
end