class WelcomeController < ApplicationController

  skip_before_filter :process_authentication
  skip_authorization_check :only => [ :index, :admin_index, :user_index, :client_index ]

  def index
  end

  def client_index
    unless current_client_user
      raise ForbiddenRequest.new
    end
  end

  def admin_index
    unless current_admin
      raise ForbiddenRequest.new
    end
  end

  def user_index
  end

end
