class IspDnsAaaaRecord < IspResourceRecord
  
  operations :dns_aaaa_get
  
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
end
