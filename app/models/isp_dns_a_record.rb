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
    r = IspDnsARecord.new flatten_hash(r)
    raise ActiveRecord::RecordNotFound unless r.type.downcase == "a"
    r 
  ensure
    asession.logout
  end

  def self.dns_a_add zonerecord,client
    asession = IspSession.login
    clientid = client.client_id.to_s
    serverid = client.default_dnsserver.to_i
    recordhash = zonerecord.dns_zone_a_record.to_ispconfig_hash.merge(default_ispconfig_hash)
    recordhash = recordhash.merge({:server_id => serverid})

    rec = { :item =>
            recordhash.collect { |k,v| {:key => k, :value => v, :attributes! => self.send("attributes_for_#{v.class.name.underscore}") } }
          }
    message = { :param0 => asession.sessionid, :param1 => clientid, :param2 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "ns2:Map" } } }

    Rails.logger.debug message

    result = super(:message => message)
    result.body[:dns_a_add_response][:return]

  ensure
    asession.logout unless asession.nil?
  end

  def dns_a_delete
    asession = IspSession.login
    result = super(:message => { :session_id => asession.sessionid, :primary_id => self.id} )
    result.body[:dns_a_delete_response][:return]
  ensure
    asession.logout unless asession.nil?
  end

  def self.default_ispconfig_hash
    {
      :type => "A",
      :aux => "0",
      :active => "y",
      :ttl => "300",
      :serial => "#{Time.now.to_i}",
      :stamp =>  "#{Time.now}"
      }
  end

  private

end
