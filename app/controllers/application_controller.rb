require 'isp_exceptions/isp_exceptions'

class ApplicationController < ActionController::Base
  include IspExceptions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_authentication_information
  before_filter :process_authentication

  check_authorization

  helper_method :current_user
    
  def initialize
    @current_user = nil
    super
  end
  
  # The current logged in user
  #
  # == Returns
  # a User object if a user is logged in and authorized. If no user is logged in, nil is returned.
  def current_user
    @current_user ||= session[:current_user]
  end

  # Create and return a request assigened Ability object.
  #
  # It gets the current running request as second parameter so CanCan may check against values in request.
  #
  # == Returns
  # A Ability object containing valid security rules
  def current_ability
    @current_ability ||= Ability.new(current_user, request)
  end

  private
  
  def set_authentication_information
    add_breadcrumb "Home", :root_path

    if current_user
      if current_user.instance_of? ClientUser
        add_breadcrumb "Client user home", :client_root_path
      end
    end
    # touch session object so updated_at is set
    session[:lastseen] = Time.now()
    # remove outdated sessions
    Session.sweep(24.hours)
  end
  
  def process_authentication
    if(is_authenticated_session)
      return true
    else
      respond_with_no_valid_authentication_found
      return false
    end
  end
  
  def is_authenticated_session
    return !current_user.nil?
  end

  def respond_with_no_valid_authentication_found
    respond_to do |format|
      format.html {
        redirect_to user_login_path and return
        # TODO flash out a message
      }
      format.json {
        render(nothing: true, status: :unauthorized)
      }
    end
  end
  
  rescue_from RequestException do |exception|
    if exception.is_a? SecurityException
      security_error_request exception
    else
      log_exception exception
      exception_request exception
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    error_request :not_found
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    error_request :not_found
  end
  
  def log_exception ex
  end
  
  def exception_request ex
    log_exception ex
    error_request ex.code, ex.message
  end

  def error_request errorcode,msg = nil
    begin
      code_number = Rack::Utils::status_code(errorcode)
      respond_to do |format|
        format.html {
          fname = "shared/#{code_number}"
          if not template_exists?(fname)
            fname = "shared/404"
          end
          @errormsg = msg
          render :file => fname, :status => errorcode
        }
        format.xml  {
          ex = Exception.new
          ex.code = errorcode
          ex.message = message
          render :xml => ex, :status => errorcode 
        }
        format.json {
          render text: msg, status: errorcode
        }
        format.any  { head errorcode }
      end
    rescue
      render text: "Error #{msg}", status: errorcode
    end
  end

end
