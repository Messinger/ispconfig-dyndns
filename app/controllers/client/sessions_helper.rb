module ClientSessionsHelper

  def authenticate_local_client_session(clientuser)
    session[:current_client_user] = clientuser
  end

  def log_out
    reset_session
  end

end
