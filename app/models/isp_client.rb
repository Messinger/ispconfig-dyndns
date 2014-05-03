class IspClient
  extend Ispremote
  
  operations :client_get_by_username, :client_get

  def initialize clientdata
    @clientdata = clientdata
  end

  def self.client_get_by_username asession,username
    return if asession.blank? || !asession.valid?
    r = super(:message => {:sessionid => asession.sessionid, :username => username})
    clientvalues = self.flatten_hash(self.response_to_hash(r))
    IspClient.new clientvalues
  end

  def self.client_get asession,id
    return if asession.blank? || !asession.valid?
    r = super(:message => {:sessionid => asession.sessionid, :client_id => id})
    clientvalues = self.flatten_hash(self.response_to_hash(r))
    IspClient.new clientvalues
  end

  def client
    @clientdata[:item]
  end

  private
 
  def self.flatten_hash r
    _h = r[:item]
    Hash[*_h.map {|v| [v[:key],self.value_to_string(v[:value])]}.flatten]
  end

end
