class Admins::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super
    info "logged in? #{current_admin}"
    current_admin.authentication_token = AuthenticationToken.new
    #render :json=> {:success=>true, :current_user=>resource.authentication_token, :current_user=>resource.login, :email=>current_user.email}
  end
end
