
class SessionsController < ApplicationController
  include SessionsHelper
  skip_authorization_check :only => [
    :adminlogin, :clientlogin, :userlogin,
    :new, :create,
    :create_for_admin, :create_for_client, :create_for_user
  ]

    #skips the check authentication for creation of session
  skip_before_filter :process_authentication,
    :only => [
    :adminlogin, :clientlogin, :userlogin,
    :new, :create,
    :create_for_admin, :create_for_client, :create_for_user
  ]
  
  def new
  end
  
  def adminlogin
    raise BadRequest.new
    @form_target = create_session_for_admin_path
    @logintype = UserHelper::ADMIN_TYPE
    self.new
    render :action => 'new'
  end

  def userlogin
    @form_target = create_session_for_user_path
    @logintype = UserHelper::USER_TYPE
    self.new
    render :action => 'new'
  end
  
  def clientlogin
    @form_target = create_session_for_client_path
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
    
    respond_to do |format|
      format.html {
        if authentication_success
          redirect_to root_path
        else
          redirect_to client_login_path
        end
      }
    end
  end

  def create_for_user
    @authtype = UserHelper::USER_TYPE
    create
  end

  def create_for_admin
    @authtype = UserHelper::ADMIN_TYPE
    create
  end # create_for_admin

  def create_for_client
    @authtype = UserHelper::CLIENT_TYPE
    create
  end # create_for_client

  def destroy
    log_out
    respond_to do |format|
      format.html {
          redirect_to root_path
      }
      format.json {
        render :nothing => true, :status => :ok
        return false
      }
    end

  end

  private
  
  def authenticate_and_start_local_session
    user = send "#{@authtype}_authenticate"
    return false if user.nil?
    authenticate_local_session(user)
    return true
  end
  
  def clientuser_authenticate
    username = params[:user][:login_id]
    password = params[:user][:password]
    
    begin
      cl = IspClientUser.find_by_username username
      if cl.is_password?(password) && cl.active == '1'
        cl = ClientUser.new cl
      else
        cl = nil
      end
    rescue ActiveRecord::RecordNotFound => ex
      # here no notfound errors for security reasons
      cl = nil
    end
    
    return ClientUserDecorator.new(cl) unless cl.nil?
    return cl

  end

end
