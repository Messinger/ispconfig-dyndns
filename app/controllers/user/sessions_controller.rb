class User::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    resource.authentication_token = AuthenticationToken.new
    if request.format.json?
      render :json => {:success=>true, :current_user => current_user.login_json}, :status => :ok
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

end
