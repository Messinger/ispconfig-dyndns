class IspDnszone
  include ActiveModel::Serializers::JSON
  extend Ispremote

  operations :dns_zone_get_by_user, :dns_zone_get
  
  def initialize aid,aorigin,data=nil
    @id = aid
    @origin = aorigin
    @data = data
  end

  def id
    @id
  end  

  def id=(id)
    @id = id
  end

  def origin
    @origin
  end

  def origin=(origin)
    @origin = origin
  end

  def data
    @data
  end

  def self.dns_zone_get_by_user asession,aclient,serverid
    return if asession.blank? || !asession.valid?
    r = super(:message => {:sessionid => asession.sessionid, :client_id => aclient.clientdata[:client_id],:server_id => serverid})
    r = self.response_to_hash r
    raise ActiveRecord::RecordNotFound unless r.has_key?(:item)
    zones = (r[:item]).collect do |zone| 
      vals = flatten_hash zone 
      i = IspDnszone.new(vals[:id],vals[:origin])
    end
  end

  def self.dns_zone_get asession,id
    return if asession.blank? || !asession.valid?
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => id})
    raise ActiveRecord::RecordNotFound if r == false
    data = flatten_hash r
    IspDnszone.new(data[:id],data[:origin],data)
  end

end

