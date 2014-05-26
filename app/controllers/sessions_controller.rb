
class SessionsController < ApplicationController
  include SessionsHelper
  skip_authorization_check :only => [
    :adminlogin, :clientlogin, :userlogin,
    :new, :create,
    :create_for_admin, :create_for_client, :create_for_user, :destroy
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
    
    if @authtype == UserHelper::USER_TYPE
      redirect_url = root_path
    elsif @authtype == UserHelper::CLIENT_TYPE
      redirect_url = client_root_path
    else
      redirect_url = root_path
    end
    
    respond_to do |format|
      format.html {
        if authentication_success
          redirect_to redirect_url
        else
          if @authtype == UserHelper::CLIENT_TYPE
            redirect_to client_login_path
          else
            redirect_to user_login_path
          end
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
    
    if current_user.nil? || current_user.instance_of?(User)
      redirect_url = root_path
    elsif current_user.instance_of? ClientUser
      redirect_url = client_root_path
    end
    log_out unless current_user.nil?

    respond_to do |format|
      format.html {
          redirect_to redirect_url
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
  
  def user_authenticate
    username = params[:user][:login_id]
    password = params[:user][:password]
    lu = User.find_by_login_id username
    logger.debug("User: #{lu.inspect}")
    return lu if lu.nil?
    logger.debug("Check pw")
    if lu.is_password?(password) && lu.active == true
        return lu
    end
    return nil
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
    cl
  end

end
