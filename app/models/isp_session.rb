class IspSession
  extend Ispremote::Soap

  operations :login, :logout

  def initialize sid
    self.sessionid = sid
  end

  def sessionid=(sid)
    @sessionid = sid
  end
  
  def sessionid
    @sessionid
  end
  
  def self.login
    loginresponse = super(:message => {:username => Setting.remote_user, :password => Setting.remote_password })
    IspSession.new loginresponse.hash[:envelope][:body][:login_response][:return]
  end

  def logout
    @loginresponse = nil
    r = super(:message => {:sessionid => @sessionid})
    @sessionid = nil
    r.hash[:envelope][:body][:logout_response][:return]
  end

  def valid?
    !@sessionid.blank?
  end

end
