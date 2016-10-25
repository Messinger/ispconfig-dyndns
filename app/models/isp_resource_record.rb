class IspResourceRecord < PresentationModel
  extend Ispremote::Soap

  attr_accessor :sys_userid, :sys_groupid, :sys_perm_user, :sys_perm_group, :sys_perm_other
  attr_accessor :server_id, :zone, :name, :type, :data, :aux, :ttl, :active, :stamp, :serial
  
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

  def self.find_by_name dnszone,name
    records = IspResourceRecord.dns_rr_get_all_by_zone dnszone
    result = []
    records.each do |record|
      ori = record.name.sub(dnszone.origin,"")
      result << record if ori.casecmp(name) == 0
    end
    result
  end
  
  def self.from_dns_zone_record record
    funcname = "from_"+record.class.name.underscore
    if self.respond_to?(funcname.to_sym)
      self.send funcname,record
    end
  end

  def self.build_remote_add_message(asession,arecord,client,adnszone)

    clientid = client.client_id.to_s
    recordhash = arecord.to_ispconfig_hash.merge(default_ispconfig_hash)
    recordhash = recordhash.merge({:server_id => adnszone.server_id})

    rec = { :item =>
                recordhash.collect { |k,v| {:key => k, :value => v, :attributes! => self.send("attributes_for_#{v.class.name.underscore}") } }
    }
    { :param0 => asession.sessionid, :param1 => clientid, :param2 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "ns2:Map" } } }

  end

  def build_remote_update_message(asession,arecord,client)
    clientid = client.client_id.to_s
    primaryid = self.id.to_i
    recordhash = arecord.to_ispconfig_hash.merge(default_ispconfig_hash)
    # overwrite default stamp
    recordhash[:serial] = gen_timestamp

    rec = { :item =>
                recordhash.collect { |k,v| {:key => k, :value => v, :attributes! => self.class.send("attributes_for_#{v.class.name.underscore}") } }
    }
    { :param0 => asession.sessionid, :param1 => clientid, :param2 => primaryid, :param3 => rec, :attributes! => { :param0 => {"xsi:type" => "xsd:string"}, :param1 => { "xsi:type" => "xsd:int" }, :param2 => {"xsi:type" => "xsd:string"}, :param3 => {"xsi:type" => "ns2:Map" } } }
  end

  def default_ispconfig_hash
    self.class.default_ispconfig_hash
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
