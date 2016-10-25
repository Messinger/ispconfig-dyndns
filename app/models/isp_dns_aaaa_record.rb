class IspDnsAaaaRecord < IspResourceRecord
  
  operations :dns_aaaa_get, :dns_aaaa_add, :dns_aaaa_update, :dns_aaaa_delete
  
  def initialize ahash=nil
    super ahash
    self.type = "AAAA"
  end

  def self.dns_aaaa_get id,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => id})
    raise ActiveRecord::RecordNotFound unless r
    r = IspDnsAaaaRecord.new flatten_hash(r)
    raise ActiveRecord::RecordNotFound unless r.type.downcase == "aaaa"
    r 
  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def self.dns_aaaa_add arecord,client, zone, usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end

    result = super(:message => build_remote_add_message(asession,arecord,client,zone))
    result.body[:dns_aaaa_add_response][:return]

  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def dns_aaaa_update arecord,client,zone,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    result = super(:message => build_remote_update_message(asession,arecord,client,zone))
    result.body[:dns_aaaa_update_response][:return]
  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def dns_aaaa_delete usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    result = super(:message => { :session_id => asession.sessionid, :primary_id => self.id} )
    result.body[:dns_aaaa_delete_response][:return]
  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def self.default_ispconfig_hash
    {
      :type => "AAAA",
      :aux => "0",
      :active => "y",
      :ttl => Setting.default_ttl,
      :serial => gen_timestamp,
      :stamp =>  "#{Time.now}"
    }
  end

end
