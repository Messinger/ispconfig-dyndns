class WelcomeController < ApplicationController

  skip_before_filter :process_authentication
  skip_authorization_check :only => [ :index ]

  def index
  end

end
