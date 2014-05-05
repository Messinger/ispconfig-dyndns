module SessionsHelper

  def authenticate_local_session(user)
    session[:authentication_token] = user.authentication_token
    session[:current_user] = user
  end

  def log_out
    reset_session
  end

end
