class RemoteJob < ActiveRecord::Base
  def completed?
    code == 0
  end
  
  def failed?
    !code.nil? && code != 0
  end
end
