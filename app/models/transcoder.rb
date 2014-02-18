class Transcoder < ActiveRecord::Base
  validates :host_name, presence: true
  validates :port, presence: true, numericality: true
end
