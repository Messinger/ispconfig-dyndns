class User::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super do |resource|
      if request.format.json?
        resource.authentication_token = AuthenticationToken.new
        set_csrf_cookie
        render :json => {:success=>true, :current_user => resource.login_json, account: current_account.as_json.merge({'type':current_account.class.name})}, :status => :ok and return
      end
    end
  end

  def destroy
    super do |resource|
      set_csrf_cookie
    end
  end

end
