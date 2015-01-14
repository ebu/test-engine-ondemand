class Tag < ActiveRecord::Base
  # Tags must have a unique name
  validates :name, uniqueness: true, presence: true
end
