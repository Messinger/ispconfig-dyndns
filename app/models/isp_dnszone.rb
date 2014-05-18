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
    zones = (r[:item]).collect do |zone| 
      vals = flatten_hash zone 
      i = IspDnszone.new(vals)
    end
  ensure 
    asession.logout unless asession.nil?
  end

  def self.dns_zone_get id
    asession = IspSession.login 
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :primary_id => id})
    raise ActiveRecord::RecordNotFound if r == false
    data = flatten_hash r
    IspDnszone.new(data)#[:id],data[:origin],data)
  ensure 
    asession.logout unless asession.nil?
  end

  def update_serial_number isp_client
    asession = IspSession.login
    cl = self.client
    clientid = isp_client.client_id
    ser = gen_timestamp
    primaryid = id
    recordhash = {
      :server_id => server_id.to_s,
      :origin => origin.to_s,
      :ns => ns.to_s,
      :mbox => mbox.to_s,
      :serial =>ser,
      :refresh => refresh.to_s,
      :expire => expire.to_s,
      :minimum => minimum.to_s,
      :ttl => ttl.to_s,
      :active => active.to_s,
      :xfer => xfer.to_s,
      :also_notify => also_notify.to_s,
      :update_acl => update_acl.to_s,
      :retry => self.retry.to_s
    }
    rec = { :item =>
            recordhash.collect { |k,v| {:key => k, :value => v, :attributes! => IspDnszone.send("attributes_for_#{v.class.name.underscore}") } }
          }
    message = { :param0 => asession.sessionid, :param1 => clientid, :param2 => primaryid, :param3 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "xsd:string"}, :param3 => {"xsi:type" => "ns2:Map" } } }
    res = cl.call :dns_zone_update, :message => message
    res.body[:dns_zone_update_response][:return]
  ensure
    asession.logout unless asession.nil?
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

