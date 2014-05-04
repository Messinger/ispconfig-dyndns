class IspResourceRecord < PresentationModel
  extend Ispremote
  
  operations :dns_rr_get_all_by_zone

  def self.dns_rr_get_all_by_zone dnszone
    asession = IspSession.login 
    r = IspResourceRecord.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => dnszone.id})
    return [] unless r.has_key?(:item)
    rrs = (r[:item]).collect do |rr|
      # IspResourceRecord.new(IspDnszone.flatten_hash(rr))
      record_object(IspDnszone.flatten_hash(rr))
    end
  ensure 
    asession.logout
  end

private
  
  def self.record_object record
    rname = "IspDns#{record[:type].capitalize}Record"
    begin
      theclass = Kernel.const_get(rname)
    rescue NameError => ex
      theclass = Kernel.const_get("IspResourceRecord")
    end
    theclass.new record
  end 
end

