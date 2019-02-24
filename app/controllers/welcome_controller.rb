class WelcomeController < ApplicationController

  respond_to :json, :html

  skip_before_action :process_authentication
  skip_authorization_check :only => [ :index, :admin_index, :user_index, :client_index, :routing ]

  def index
    if request.format.json?
      render nothing: true
    end
  end

  def client_index
  end

  def admin_index

    if request.format.json?
      render nothing: true
    end

  end

  def user_index
  end

  def routing
    error_request(:not_found, "No route matches [#{request.method}] #{request.path}")
  end

end
