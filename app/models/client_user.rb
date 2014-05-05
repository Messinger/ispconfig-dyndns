
class ClientUser 
  include User
  
  def initialize(isp_client)
    self.login_id = isp_client.username
    self.authentication_token = isp_client.passwort
    self.password = isp_client.passwort
    self.id = isp_client.id
  end

end