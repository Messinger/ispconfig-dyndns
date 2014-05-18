class IspDnsAaaaRecord < IspResourceRecord
  
  operations :dns_aaaa_get, :dns_aaaa_add, :dns_aaaa_update, :dns_aaaa_delete
  
  def initialize ahash=nil
    super ahash
    self.type = "AAAA"
  end

  def self.dns_aaaa_get id
    asession = IspSession.login
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => id})
    raise ActiveRecord::RecordNotFound if r == false
    r = IspDnsAaaaRecord.new flatten_hash(r)
    raise ActiveRecord::RecordNotFound unless r.type.downcase == "aaaa"
    r 
  ensure
    asession.logout
  end

  def self.dns_aaaa_add arecord,client
    asession = IspSession.login
    clientid = client.client_id.to_s
    serverid = client.default_dnsserver.to_i
    recordhash = arecord.to_ispconfig_hash.merge(default_ispconfig_hash)
    recordhash = recordhash.merge({:server_id => serverid})

    rec = { :item =>
            recordhash.collect { |k,v| {:key => k, :value => v, :attributes! => self.send("attributes_for_#{v.class.name.underscore}") } }
          }
    message = { :param0 => asession.sessionid, :param1 => clientid, :param2 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "ns2:Map" } } }

    Rails.logger.debug message

    result = super(:message => message)
    result.body[:dns_aaaa_add_response][:return]

  ensure
    asession.logout unless asession.nil?
  end

  def dns_aaaa_update arecord,client
    asession = IspSession.login
    clientid = client.client_id.to_s
    primaryid = self.id.to_i
    recordhash = arecord.to_ispconfig_hash.merge(IspDnsAaaaRecord.default_ispconfig_hash)
    # overwrite default stamp
    recordhash[:serial] = gen_timestamp
    rec = { :item =>
            recordhash.collect { |k,v| {:key => k, :value => v, :attributes! => IspDnsAaaaRecord.send("attributes_for_#{v.class.name.underscore}") } }
          }
    message = { :param0 => asession.sessionid, :param1 => clientid, :param2 => primaryid, :param3 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "xsd:string"}, :param3 => {"xsi:type" => "ns2:Map" } } }
    result = super(:message => message)
    result.body[:dns_aaaa_update_response][:return]
  ensure
    asession.logout unless asession.nil?
  end

  def dns_aaaa_delete
    asession = IspSession.login
    result = super(:message => { :session_id => asession.sessionid, :primary_id => self.id} )
    result.body[:dns_aaaa_delete_response][:return]
  ensure
    asession.logout unless asession.nil?
  end

  def self.default_ispconfig_hash
    {
      :type => "AAAA",
      :aux => "0",
      :active => "y",
      :ttl => "300",
      :serial => gen_timestamp,
      :stamp =>  "#{Time.now}"
    }
  end

end
