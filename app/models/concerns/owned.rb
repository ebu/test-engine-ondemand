module Owned
  extend ActiveSupport::Concern
  
  included do
    # scopes, class thingies
    validates :user_id, presence: true
    
    belongs_to :user, primary_key: 'ebu_id', foreign_key: 'user_id'
  end
  
  module ClassMethods
    # class methods
    def owned(user)
      where(user_id: user.ebu_id)
    end
    
    def owned_or_referenced(user)
      where(["user_id = ? OR is_reference = ?", user.ebu_id, true])
    end
  end

  # instance methods
  def owned_by?(user)
    self.user_id == user.ebu_id
  end
  
  def can_be_destroyed_by?(user, is_admin)
    (self.owned_by?(user) || is_admin) && !self.is_reference?
  end
end