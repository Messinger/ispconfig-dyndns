class Admins::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super do |resource|
      if request.format.json?
        resource.authentication_token = AuthenticationToken.new
        render :json => {:success=>true, account: current_account.as_json.merge({'type':current_account.class.name})}, :status => :ok and return
      end
    end
  end

end
