class IspClient
  extend Ispremote
  
  operations :client_get_by_username, :client_get

  def initialize clientdata
    @clientdata = clientdata
  end

  def self.client_get_by_username asession,username
    return if asession.blank? || !asession.valid?
    r = super(:message => {:sessionid => asession.sessionid, :username => username})
    #self.response_to_hash r
    clientvalues = self.flatten_hash(self.response_to_hash(r))
    IspClient.new clientvalues
  end

  def self.client_get asession,aclient
    return if asession.blank? || !asession.valid?
    if aclient.is_a? IspClient
      id = aclient.clientdata[:client_id]
    else
      id = aclient
    end
    r = super(:message => {:sessionid => asession.sessionid, :client_id => id})
    clientvalues = self.flatten_hash(self.response_to_hash(r))
    IspClient.new clientvalues
  end

  def clientdata
    @clientdata
  end

  private
 

end
