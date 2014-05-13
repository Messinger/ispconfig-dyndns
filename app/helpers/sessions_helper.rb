module SessionsHelper

  def authenticate_local_session(user)
    session[:current_user] = user
  end

  def log_out
    reset_session
  end

end
