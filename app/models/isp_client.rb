class IspClient < PresentationModel
  extend Ispremote::Soap
  include UserHelper::GeneralUser
  
  operations :client_get, :client_get_id

  def initialize data
    super data
    set_id client_id
  end

  def dns_server_list
    @dns_server_list ||= build_dns_server_list
  end

  # get Client by client ID
  def self.client_get aclientuser, usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    if aclientuser.is_a? IspClientUser
      id = aclientuser.client_id
    else
      id = aclientuser
    end
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :client_id => id})
    raise ActiveRecord::RecordNotFound if r==false || !r.has_key?(:item)
    clientvalues = self.flatten_hash(r)
    IspClient.new clientvalues
  ensure 
    asession.logout if !asession.nil? && usesession.nil?
  end

  # get client id assigned to client _user_ id!
  def self.client_get_id aclientuser,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    if aclientuser.is_a? IspClientUser
      id = aclientuser.userid
    else
      id = aclientuser
    end
    begin
      self.response_to_hash super(:message => {:sessionid => asession.sessionid, :client_id => id})
    rescue Savon::SOAPFault => ex
      raise ActiveRecord::RecordNotFound
    end
  ensure 
    asession.logout if !asession.nil? && usesession.nil?
  end
  
  def self.client_for_user aclientuser,usesession=nil
    if usesession.nil?
      asession = IspSession.login
    else
      asession = usesession
    end
    client_id = self.client_get_id aclientuser,asession
    self.client_get client_id,asession
  ensure
    asession.logout if !asession.nil? && usesession.nil?
  end

  def build_dns_server_list
    if dns_servers.is_a? String
      dns_servers.split(',').map!(&:to_i).select { |item| item > 0 }
    else
      []
    end
  end

end
