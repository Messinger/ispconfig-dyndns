class IspClient
  extend Ispremote
  
  operations :client_get_by_username, :client_get

  def initialize clientdata
    @clientdata = clientdata
  end

  def id
    clientdata[:client_id]
  end

  def self.client_get_by_username asession,username
    return if asession.blank? || !asession.valid?
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :username => username})
    raise ActiveRecord::RecordNotFound if r==false
    clientvalues = self.flatten_hash(r)
    IspClient.new clientvalues
  end

  def self.client_get asession,aclient
    return if asession.blank? || !asession.valid?
    if aclient.is_a? IspClient
      id = aclient.clientdata[:client_id]
    else
      id = aclient
    end
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :client_id => id})
    raise ActiveRecord::RecordNotFound if r==false || !r.has_key?(:item)
    clientvalues = self.flatten_hash(r)
    IspClient.new clientvalues
  end

  def clientdata
    @clientdata
  end

  private
 

end
