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

    Rails.logger.debug build_remote_add_message(asession,arecord,client)

    result = super(:message => build_remote_add_message(asession,arecord,client))
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

    result = super(:message => build_remote_update_message(asession,arecord,client))
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
