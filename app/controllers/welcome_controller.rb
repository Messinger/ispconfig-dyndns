class WelcomeController < ApplicationController

  skip_before_filter :process_authentication
  skip_authorization_check :only => [ :index, :admin_index, :user_index, :client_index ]

  def index
  end

  def client_index
  end

  def admin_index
  end

  def user_index
  end

end
