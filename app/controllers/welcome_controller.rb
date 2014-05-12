class WelcomeController < ApplicationController

  skip_before_filter :process_authentication

  def index
  end

end
