class Client::SessionsController < ApplicationController
  skip_authorization_check :only => [
                               :clientlogin,
                               :new, :create,
                               :create_for_client, :destroy
                           ]

  #skips the check authentication for creation of session
  skip_before_action :process_authentication,
                     :only => [
                         :clientlogin,
                         :new, :create,
                         :create_for_client
                     ]

  def new
  end

  def clientlogin
    @form_target = client_create_session_path
    @logintype = UserHelper::CLIENT_TYPE
    self.new
    render :action => 'new'
  end

  def create
    begin
      authentication_success = authenticate_and_start_local_session
    rescue Exception => ex
      raise ex
    end

    redirect_url = client_root_path
    if authentication_success
      jsonstatus = :ok
      json_response = {account: current_account.as_json.merge({'type':current_account.class.name})}
      if json_request?
        cookies["CSRF-TOKEN"] = form_authenticity_token
      end
    else
      jsonstatus = 401
      json_response = {account: nil}
    end

    respond_to do |format|
      format.html {
        if authentication_success
          redirect_to redirect_url
        else
          redirect_to client_login_path
        end
      }
      format.json {
        render :json => json_response, status: jsonstatus
      }
    end
  end

  def create_for_client
    @authtype = UserHelper::CLIENT_TYPE
    create
  end

  # create_for_client

  def destroy

    redirect_url = client_root_path
    reset_session unless current_client_user.nil?
    set_csrf_cookie

    respond_to do |format|
      format.html {
        redirect_to redirect_url
      }
      format.json {
        render :json => {}, :status => :ok
      }
    end

  end

  private

  def authenticate_and_start_local_session
    user = send "#{@authtype}_authenticate"
    return false if user.nil?
    session[:current_client_user] = user
    true
  end

  def clientuser_authenticate
    if params[:client]
      username = params[:client][:login_id]
      password = params[:client][:password]
    else
      username = params[:user][:login_id]
      password = params[:user][:password]
    end

    begin
      cl = IspClientUser.find_by_username username
      if cl.is_password?(password) && cl.active == '1'
        cl = ClientUser.new cl
      else
        cl = nil
      end
    rescue ActiveRecord::RecordNotFound => ex
      # here no notfound errors for security reasons
      info ex
      cl = nil
    rescue => ex
      cl = nil
      error ex
    end
    cl
  end

end

