class Organization < ActiveRecord::Base
  validates :name,   presence: true, uniqueness: true
  validates :ebu_id, presence: true, uniqueness: true
  
  has_many :users, foreign_key: 'organization_id', primary_key: 'ebu_id'
  
  def self.refresh
    if organizations = self.get_orga_list
      self.destroy_all(["ebu_id NOT IN (?)", organizations.collect { |o| o["id"] }])
      organizations.each do |o|
        organization = self.find_or_initialize_by(ebu_id: o["id"])
        organization.name = o["name"]
        organization.save
      end
    end
  end
  
  private
  
  def self.get_orga_list
    begin
      response = RestClient::Request.execute(
        method: :get,
        url: EBU::API_URL + "/orgas/",
        timeout: EBU::NETWORK_TIMEOUT,
        open_timeout: EBU::NETWORK_TIMEOUT
      )
      if response.code == 200
        if (obj = JSON.parse(response.to_str))
          obj["data"]
        end
      else
        nil
      end
    rescue Timeout::Error => e
      nil
    rescue => e
      nil
    end
  end
end
