require 'isp_exceptions/isp_exceptions'
require 'logging/applogger'

class ApplicationController < ActionController::Base
  include IspExceptions
  include Applogger

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, if: Proc.new {|c| c.request.format.json? }

  #before_action :authenticate_user!

  before_action :authenticate_user_from_token!, :unless => :devise_controller?

  check_authorization :unless => :devise_controller?

  before_action :set_authentication_information, unless: :devise_controller?
  before_action :process_authentication, unless: :devise_controller?

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_signup_complete, unless: :devise_controller? #, only: [:new, :create, :update, :destroy]

  helper_method :current_account, :current_client_user, :current_api_key

  def initialize
    @current_client_user = nil
    @current_api_key = nil
    @logger = getlogger("ApplicationController::#{self.class.logger_name}")
    @logger.debug "Finished initialize"
    @logger.debug "Is devise-controller: #{devise_controller?}"
    super
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  def current_api_key
    return @current_api_key unless @current_api_key.nil?
    unless params[:accesstoken].nil?
      api_key = ApiKey.find_by_access_token params[:accesstoken]
      unless api_key.nil?
        @current_api_key = api_key if api_key.active_for_authentication?
      end
      raise ForbiddenRequest.new "Token not valid or user locked" if @current_api_key.nil?
    end
    debug "Got apikey #{@current_api_key}"
    @current_api_key
  end

  def current_client_user
    @current_client_user ||= session[:current_client_user]
  end

  def current_account
    current_user || current_admin || current_client_user || current_api_key
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

  def can?(action,subject,*extra)
    if subject.kind_of?(ApplicationDecorator)
      super(action,subject.model,*extra)
    else
      super(action,subject,*extra)
    end
  end

  private

  def set_authentication_information
    add_breadcrumb "Home", :root_path

    if current_client_user
      add_breadcrumb "Client user home", :client_root_path
    end
    # don't need a session when access via api-key or not authenticated
    if is_authenticated_session && current_api_key.nil? && !request.format.json?
      # touch session object so updated_at is set
      session[:lastseen] = Time.now()
    end
  end

  def process_authentication
    if is_authenticated_session
      true
    else
      respond_with_no_valid_authentication_found
      false
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

  def log_exception(ex)
  end

  # @param [Object] ex
  def exception_request(ex)
    log_exception ex
    error_request ex.code, ex.message
  end

  # @param [Object] errorcode
  # @param [Object] msg
  def error_request(errorcode, msg = nil)
    begin
      code_number = Rack::Utils::status_code(errorcode)
      respond_to do |format|
        format.html {
          fname = "shared/#{code_number}"
          unless template_exists?(fname)
            fname = "shared/404"
          end
          @errormsg = msg
          render :file => fname, :status => errorcode
        }
        format.xml {
          ex = Exception.new
          ex.code = errorcode
          ex.message = message
          render :xml => ex, :status => errorcode
        }
        format.json {
          render :json => {:resultText => msg, :resultCode => errorcode}, status: errorcode
        }
        format.any { head errorcode }
      end
    rescue
      render text: "Error #{msg}", status: errorcode
    end
  end

#  def verified_request?
#    if request.content_type == "application/json"
#      return true
#    else
#      return super()
#    end
#  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:last_name, :first_name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:last_name, :first_name, :email, :password, :password_confirmation, :current_password) }
  end

  def authenticate_user_from_token!

    token_value = request.headers['X-AUTHENTICATIONTOKEN']
    return if token_value.blank?
    token = AuthenticationToken.find_by_token token_value

    if !token.nil? && !token.active_for_authentication?
      raise ForbiddenRequest.new "Token not valid or user locked"
    end

    #user_token = params[:user_token].presence

    if token && token.account
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in(token.account, store: false)
    end

  end
end
