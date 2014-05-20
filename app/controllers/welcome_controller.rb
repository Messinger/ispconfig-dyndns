class WelcomeController < ApplicationController

  skip_before_filter :process_authentication
  skip_authorization_check :only => [ :index, :admin_index ]

  def index
  end

  def admin_index
    if current_user && !current_user.instance_of?(ClientUser)
      raise ForbiddenRequest.new
    end
  end

end
