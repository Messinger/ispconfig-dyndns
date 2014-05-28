
class ClientUser 
  include UserHelper::GeneralUser

  attr_accessor :login_id, :password, :id, :client_id

  def initialize(isp_client)
    self.login_id = isp_client.username
    self.password = isp_client.passwort
    self.client_id = isp_client.client_id
    self.id = isp_client.id
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

  def is_admin?
    false
  end
  
  def user_type
    UserHelper::CLIENT_TYPE
  end

end
