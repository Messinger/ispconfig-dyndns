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
    
    rec = { :item => [
        {:key => :server_id, :value => serverid},
        {:key => :zone, :value => zonerecord.dns_zone.isp_dnszone_id},
        {:key => :name, :value => zonerecord.name},
        {:key => :type, :value => "A"},
        {:key => :data, :value => zonerecord.dns_zone_a_record.address},
        {:key => :aux, :value => "0"},
        {:key => :ttl, :value => "300"},
        {:key => :active, :value => "y"},
        {:key => :serial, :value => 1},
        {:key => :stamp, :value => "CURRENT_TIMESTAMP"}
                     ]
    }
    
    message = { :param0 => asession.sessionid, :param1 => clientid, 'param2' => rec}

    Rails.logger.debug message

    result = super(:message => message)
    result.body
  ensure
    asession.logout unless asession.nil?
  end

end
