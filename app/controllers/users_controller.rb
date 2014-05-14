class UsersController < ApplicationController
  
  skip_before_filter :process_authentication, :only => [ :new, :create ]
  skip_authorization_check :only => [ :new, :create ]
  
  def index
  end
  
  def show
  end
  
  def new
  end
  
  def create
  end
  
  def update
  end
  
  def destroy
  end
  
end
