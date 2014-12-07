require 'isp_exceptions/isp_exceptions'
require 'logging/applogger'

class ApplicationController < ActionController::Base
  include IspExceptions
  include Applogger

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
 
  #before_action :authenticate_user!
  
  check_authorization :unless => :devise_controller? 
  
  before_filter :set_authentication_information, unless: :devise_controller?
  before_filter :process_authentication, unless: :devise_controller?
 
  before_filter :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_account, :current_client_user, :current_api_key
    
  def initialize
    @current_client_user = nil
    @current_api_key = nil
    @logger = getlogger("ApplicationController::#{self.class.logger_name}")
    @logger.debug "Finished initialize"
    @logger.debug "Is devise-controller: #{devise_controller?}"
    super
  end

  def current_api_key
    return @current_api_key unless @current_api_key.nil?
    unless params[:accesstoken].nil?
      api_key = ApiKey.find_by_access_token params[:accesstoken]
      @current_api_key = api_key if api_key && api_key.active_for_authentication?
    end
    debug "Got apikey #{@current_api_key}"
    @current_api_key
  end

  def current_client_user
    @current_client_user ||= session[:current_client_user]
  end
  
  def current_account
    current_user || current_admin || current_client_user ||  current_api_key
  end
  
  # Create and return a request assigened Ability object.
  #
  # It gets the current running request as second parameter so CanCan may check against values in request.
  #
  # == Returns
  # A Ability object containing valid security rules
  def current_ability
    @current_ability ||= Ability.new(current_account, request)
  end

  private
  
  def set_authentication_information
    add_breadcrumb "Home", :root_path

    if current_client_user
      add_breadcrumb "Client user home", :client_root_path
    end
    # touch session object so updated_at is set
    session[:lastseen] = Time.now()
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
    return !current_account.nil?
  end

  def respond_with_no_valid_authentication_found
    respond_to do |format|
      format.html {
        redirect_to new_user_session_path and return
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
    error "Access denied on #{exception.action} #{exception.subject.inspect}"
    error_request :not_found
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    error "Record not found: #{exception.message}"
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

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:last_name, :first_name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit( :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:last_name, :first_name, :email, :password, :password_confirmation, :current_password) }
  end

end
