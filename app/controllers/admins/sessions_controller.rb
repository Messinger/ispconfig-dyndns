class Admins::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    session[:lastseen] = Time.now()
    super

    #render :json=> {:success=>true, :current_user=>resource.authentication_token, :current_user=>resource.login, :email=>current_user.email}
  end
end
