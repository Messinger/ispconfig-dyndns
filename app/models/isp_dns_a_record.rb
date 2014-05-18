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
    
    rec = { :item => 
            [
            {:key => :server_id, :value => serverid, :attributes! => int_attributes},
            {:key => :zone, :value => zonerecord.dns_zone.isp_dnszone_id, :attributes! => int_attributes },
            {:key => :name, :value => zonerecord.name, :attributes! => string_attributes},
            {:key => :type, :value => "A", :attributes! => string_attributes},
            {:key => :data, :value => zonerecord.dns_zone_a_record.address, :attributes! => string_attributes},
            {:key => :aux, :value => "0", :attributes! => string_attributes},
            {:key => :ttl, :value => "300", :attributes! => string_attributes},
            {:key => :active, :value => "y", :attributes! => string_attributes},
            {:key => :serial, :value => 1, :attributes! => string_attributes},
            {:key => :stamp, :value => Time.now.to_i, :attributes! => string_attributes}
            ]
    }
    
    message = { :param0 => asession.sessionid, :param1 => clientid, :param2 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "ns2:Map" } } }
    
    Rails.logger.debug message

    result = super(:message => message)
    result.body[:dns_a_add_response][:return]

  ensure
    asession.logout unless asession.nil?
  end

  private
  
  def self.int_attributes
      { :key => { "xsi:type" => "xsd:string"}, :value => {"xsi:type" => "xsd:int" } }
  end

  def self.string_attributes
      { :key => { "xsi:type" => "xsd:string"}, :value => {"xsi:type" => "xsd:string" } }
  end

end
