class Organization < ActiveRecord::Base
  validates :name,   presence: true, uniqueness: true
  validates :ebu_id, presence: true, uniqueness: true
  
  has_many :users, foreign_key: 'organization_id', primary_key: 'ebu_id'
end
