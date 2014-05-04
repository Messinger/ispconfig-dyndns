class IspDnszone
  include ActiveModel::Serializers::JSON
  extend Ispremote

  operations :dns_zone_get_by_user
  
  def initialize aid,aorigin
    @id = aid
    @origin = aorigin
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

  def self.dns_zone_get_by_user asession,aclient,serverid
    return if asession.blank? || !asession.valid?
    r = super(:message => {:sessionid => asession.sessionid, :client_id => aclient.clientdata[:client_id],:server_id => serverid})
    zones = (self.response_to_hash(r)[:item]).collect do |zone| 
        vals = flatten_hash zone 
        i = IspDnszone.new(vals[:id],vals[:origin])
      end
  end

end

