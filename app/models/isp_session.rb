class IspSession
  extend Savon::Model

  client :endpoint => "https://web03.alwin-it.de:8080/remote/index.php", :ssl_verify_mode => :none, :namespace => "http://www.w3.org/2003/05/soap-envelope",:strip_namespaces => true, :convert_request_keys_to => :none

  global :basic_auth, "alwin", ""

  operations :login, :logout

  def login(username, password)
    @sessionid = nil
    @loginresponse = nil
    @loginresponse = super(:message => {:username => username, :password => password })

    @sessionid = @loginresponse.hash[:envelope][:body][:login_response][:return]
  end

  def logout
    @loginresponse = nil

    r = super(:message => {:sessionid => @sessionid})
    @sessionid = nil
    r.hash[:envelope][:body][:logout_response][:return]
  end

  def sessionid
    @sessionid
  end

  def valid?
    !@sessionid.blank?
  end

end

