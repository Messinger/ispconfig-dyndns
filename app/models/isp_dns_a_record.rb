class IspDnsARecord < IspResourceRecord

  operations :dns_a_get, :dns_a_add, :dns_a_update, :dns_a_delete

  def initialize ahash=nil
    super ahash
    self.type = "A"
  end

  def self.dns_a_get id
    asession = IspSession.login
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => id})
    raise ActiveRecord::RecordNotFound if r == false
    r = IspDnsAaaaRecord.new flatten_hash(r)
    raise ActiveRecord::RecordNotFound unless r.type.downcase == "a"
    r 
  ensure
    asession.logout
  end

  def self.dns_a_add zonerecord,client
    asession = IspSession.login
    clientid = client.client_id
    serverid = client.default_dnsserver
    rec = IspDnsARecord.new
    
    rec = {
        :server_id => serverid,
        :zone => zonerecord.dns_zone.isp_dnszone_id,
        :type => "a",
        :data => zonerecord.dns_zone_a_record.address,
        :name => zonerecord.name,
        :ttl => "300",
        :active => "y",
        :aux => "0",
        :serial => "1",
        :stamp => "#{Time.now.to_i}"
    }
    
    message = { :session_id => asession.sessionid, :client_id => clientid, :params => rec}

    p message
    result = super(:message => message)
    result.body
  ensure
    asession.logout unless asession.nil?
  end

end
