require 'isp_exceptions/isp_exceptions'

class ApplicationController < ActionController::Base
  include IspExceptions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
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

  private
  
  def is_authenticated_session
    return !current_user.nil?
  end

  rescue_from RequestException do |exception|
    if exception.is_a? SecurityException
      security_error_request exception
    else
      log_exception exception
      exception_request exception
    end
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
