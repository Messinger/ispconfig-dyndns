class Dnszone
  extend Ispremote
  
  operations :dns_zone_get_by_user
  
  def self.dns_zone_get_by_user asession,aclient,serverid
    return if asession.blank? || !asession.valid?
    r = super(:message => {:sessionid => asession.sessionid, :client_id => aclient.clientdata[:client_id],:server_id => serverid})
    self.response_to_hash(r)
  end

end

