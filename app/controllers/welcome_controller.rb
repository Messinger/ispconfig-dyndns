class WelcomeController < ApplicationController

  skip_before_filter :process_authentication
  skip_authorization_check :only => [ :index, :admin_index, :user_index ]

  def index
  end

  def admin_index
    if current_account && !current_account.instance_of?(ClientUser)
      raise ForbiddenRequest.new
    end
  end

  def user_index
  end

end
