class IspSession
  extend Ispremote

  operations :login, :logout

  def login
    @sessionid = nil
    @loginresponse = nil
    @loginresponse = super(:message => {:username => Setting.remote_user, :password => Setting.remote_password })
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

