class IspClient
  extend Savon::Model

  client :endpoint => "https://web03.alwin-it.de:8080/remote/index.php", :ssl_verify_mode => :none, :namespace => "http://www.w3.org/2003/05/soap-envelope",:strip_namespaces => true, :convert_request_keys_to => :none

  operations :client_get_by_username, :client_get

  def initialize clientdata
    @clientdata = clientdata
  end

  def self.client_get_by_username asession,username
    return if asession.blank? || !asession.valid?
    r = super(:message => {:sessionid => asession.sessionid, :username => username})
    clientvalues = r.hash[:envelope][:body][:client_get_by_username_response][:return]
    IspClient.new clientvalues
  end

  def self.client_get asession,id
    return if asession.blank? || !asession.valid?
    r = super(:message => {:sessionid => asession.sessionid, :client_id => id})
    clientvalues = r.hash[:envelope][:body][:client_get_response][:return]
    IspClient.new clientvalues
  end

  def client
    @clientdata[:item]
  end
end
