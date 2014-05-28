require 'isp_exceptions/isp_exceptions'

class ApplicationController < ActionController::Base
  include IspExceptions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
 
  before_action :authenticate_user!
  
  check_authorization :unless => :devise_controller? 
    
  def initialize
    @current_client_user = nil
    super
  end

  def current_client_user
    @current_client_user ||= session[:current_client_user]
  end
  
  def current_account
    current_user || current_client_user
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
  
  
  rescue_from RequestException do |exception|
    if exception.is_a? SecurityException
      security_error_request exception
    else
      log_exception exception
      exception_request exception
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.error "Access denied on #{exception.action} #{exception.subject.inspect}"
    error_request :not_found
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    Rails.logger.error "Record not found: #{exception.message}"
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
