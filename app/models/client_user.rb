
class ClientUser 
  include User
  
  attr_accessor :client_id, :id
  
  def initialize(isp_client)
    self.login_id = isp_client.username
    self.password = isp_client.passwort
    self.id = isp_client.id
    self.client_id = isp_client.client_id
  end

  # copied from ActiveRecord
  def persisted?
    !(self.id.nil?)
  end
  
  # copied from ActiveRecord
  def new_record?
    !persisted?
  end

  def set_id(id)
    @id = id
  end
  
end
