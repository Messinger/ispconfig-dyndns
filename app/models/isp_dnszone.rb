class IspDnszone < PresentationModel
  extend Ispremote

  attr_accessor :sys_userid, :sys_groupid, :origin, :sys_perm_user, :sys_perm_group, :sys_perm_other, :server_id, :ns, :mbox, :serial, :refresh
  attr_accessor :retry, :expire, :minimum, :ttl, :active, :xfer, :also_notify, :update_acl
  
  operations :dns_zone_get_by_user, :dns_zone_get, :dns_rr_get_all_by_zone
  
  def self.dns_zone_get_by_user aclient,serverid
    asession = IspSession.login 
    r = super(:message => {:sessionid => asession.sessionid, :client_id => aclient.client_id,:server_id => serverid})
    r = self.response_to_hash r
    return [] unless r.has_key?(:item)
    zones = (r[:item]).collect do |zone| 
      vals = flatten_hash zone 
      i = IspDnszone.new(vals)
    end
  ensure 
    asession.logout
  end

  def self.dns_zone_get id
    asession = IspSession.login 
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => id})
    raise ActiveRecord::RecordNotFound if r == false
    data = flatten_hash r
    IspDnszone.new(data)#[:id],data[:origin],data)
  ensure 
    asession.logout
  end
  
  def dns_rr_get_all_by_zone
    asession = IspSession.login 
    r = IspDnszone.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => self.id})
    return [] unless r.has_key?(:item)
    rrs = (r[:item]).collect do |rr|
      IspDnszone.flatten_hash rr
    end
  ensure 
    asession.logout
  end

end

