class IspDnsCnameRecord < IspResourceRecord

  operations :dns_cname_get, :dns_cname_add, :dns_cname_update, :dns_cname_delete

  def initialize ahash=nil
    super ahash
    self.type = "CNAME"
  end

  def self.dns_cname_get id,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => id})
    raise ActiveRecord::RecordNotFound unless r
    r = IspDnsCnameRecord.new flatten_hash(r)
    raise ActiveRecord::RecordNotFound unless r.type.downcase == "cname"
    r
  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

end