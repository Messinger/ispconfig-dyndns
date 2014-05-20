class IspDnszone < PresentationModel
  extend Ispremote::Soap

  attr_accessor :sys_userid, :sys_groupid, :origin, :sys_perm_user, :sys_perm_group, :sys_perm_other, :server_id, :ns, :mbox, :serial, :refresh
  attr_accessor :retry, :expire, :minimum, :ttl, :active, :xfer, :also_notify, :update_acl, :records
  
  operations :dns_zone_get_by_user, :dns_zone_get
  
  def self.dns_zone_get_by_user aclient,serverid
    asession = IspSession.login 
    r = super(:message => {:sessionid => asession.sessionid, :client_id => aclient.client_id,:server_id => serverid})
    r = self.response_to_hash r
    return [] unless r.has_key?(:item)
    if r[:item].is_a? Array
      zones = (r[:item]).collect do |zone|
        vals = flatten_hash zone
        i = IspDnszone.new(vals)
      end
    elsif r[:item].is_a? Hash
      zones = []
      if r[:item].has_key?(:item)
        vals = flatten_hash r[:item]
        zones << IspDnszone.new(vals)
      end
    end
  ensure 
    asession.logout unless asession.nil?
  end

  def self.dns_zone_get id,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => id})
    raise ActiveRecord::RecordNotFound if r == false
    data = flatten_hash r
    IspDnszone.new(data)#[:id],data[:origin],data)
  ensure 
    asession.logout if !asession.nil? && usesession.nil?
  end

  def update_serial_number isp_client,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    cl = self.client
    clientid = isp_client.client_id
    ser = self.gen_timestamp
    primaryid = self.id
    recordhash = {
      :server_id => self.server_id,
      :origin => self.origin,
      :ns => self.ns,
      :mbox => self.mbox,
      :serial =>ser,
      :refresh => self.refresh,
      :expire => self.expire,
      :minimum => self.minimum,
      :ttl => self.ttl,
      :active => self.active,
      :xfer => self.xfer,
      :also_notify => self.also_notify,
      :update_acl => self.update_acl,
      :retry => self.retry
    }
    rec = { :item =>
            recordhash.collect { |k,v| {:key => k, :value => v, :attributes! => self.class.send("attributes_for_#{v.class.name.underscore}") } }
          }
    message = { :param0 => asession.sessionid, :param1 => clientid, :param2 => primaryid, :param3 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "xsd:string"}, :param3 => {"xsi:type" => "ns2:Map" } } }
    res = cl.call :dns_zone_update, :message => message
    res.body[:dns_zone_update_response][:return]
  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def records
    @records ||= self.retrieve_records
  end  

  def retrieve_records
    IspResourceRecord.dns_rr_get_all_by_zone self
  end

  def find_record_by_name name
    IspResourceRecord.find_by_name self,name
  end

end

