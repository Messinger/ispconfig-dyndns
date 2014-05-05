class IspClient < PresentationModel
  extend Ispremote::Soap
  include UserHelper::User
  
  operations :client_get_by_username, :client_get

  def initialize data
    super data
    set_id client_id
  end

  def self.client_get_by_username username
    asession = IspSession.login
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :username => username})
    raise ActiveRecord::RecordNotFound if r==false
    clientvalues = self.flatten_hash(r)
    IspClient.new clientvalues
  ensure 
    asession.logout
  end

  def self.client_get aclient
    asession = IspSession.login
    if aclient.is_a? IspClient
      id = aclient.clientdata[:client_id]
    else
      id = aclient
    end
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :client_id => id})
    raise ActiveRecord::RecordNotFound if r==false || !r.has_key?(:item)
    clientvalues = self.flatten_hash(r)
    IspClient.new clientvalues
  ensure 
    asession.logout unless asession.nil?
  end

  def self.find_by_username username
    client_get_by_username username
  end

  def authentication_token
    self.passwort
  end
  
end
