class IspDnsARecord < IspResourceRecord

  operations :dns_a_get, :dns_a_add, :dns_a_update, :dns_a_delete

  def initialize ahash=nil
    super ahash
    self.type = "A"
  end

  def self.dns_a_get id,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => id})
    raise ActiveRecord::RecordNotFound if r == false
    r = IspDnsARecord.new flatten_hash(r)
    raise ActiveRecord::RecordNotFound unless r.type.downcase == "a"
    r 
  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def self.dns_a_add arecord,client,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    clientid = client.client_id
    serverid = client.default_dnsserver
    recordhash = arecord.to_ispconfig_hash.merge(default_ispconfig_hash)
    recordhash = recordhash.merge({:server_id => serverid})

    rec = { :item =>
            recordhash.collect { |k,v| {:key => k, :value => v, :attributes! => self.send("attributes_for_#{v.class.name.underscore}") } }
          }
    message = { :param0 => asession.sessionid, :param1 => clientid, :param2 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "ns2:Map" } } }

    Rails.logger.debug message

    result = super(:message => message)
    result.body[:dns_a_add_response][:return]

  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def dns_a_update arecord,client,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    clientid = client.client_id.to_s
    primaryid = self.id.to_i
    recordhash = arecord.to_ispconfig_hash.merge(IspDnsARecord.default_ispconfig_hash)
    # overwrite default stamp
    recordhash[:serial] = gen_timestamp

    rec = { :item =>
            recordhash.collect { |k,v| {:key => k, :value => v, :attributes! => self.class.send("attributes_for_#{v.class.name.underscore}") } }
          }
    message = { :param0 => asession.sessionid, :param1 => clientid, :param2 => primaryid, :param3 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "xsd:string"}, :param3 => {"xsi:type" => "ns2:Map" } } }
    result = super(:message => message)
    result.body[:dns_a_update_response][:return]
  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def dns_a_delete usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    result = super(:message => { :session_id => asession.sessionid, :primary_id => self.id} )
    result.body[:dns_a_delete_response][:return]
  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def self.default_ispconfig_hash
    {
      :type => "A",
      :aux => "0",
      :active => "y",
      :ttl => Setting.default_ttl,
      :serial => gen_timestamp,
      :stamp =>  "#{Time.now}"
      }
  end

  private

end
