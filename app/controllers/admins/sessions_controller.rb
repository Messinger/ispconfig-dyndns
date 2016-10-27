class Admins::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super do |resource|
      if request.format.json?
        resource.authentication_token = AuthenticationToken.new
        render :json => {:success=>true, :current_user => resource.login_json}, :status => :ok and return
      end
    end
  end

end
