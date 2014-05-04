class IspDnsARecord < IspResourceRecord

  operations :dns_a_get

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

end
