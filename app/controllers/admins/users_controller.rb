class Admins::UsersController < ApplicationController
  authorize_resource :class => User

  respond_to :json, :html

  def index
    @users = User.accessible_by(current_ability)
    respond_to do |format|
      format.html {respond_with @users}
      format.json {
        respond_with @users.as_json(:include => [:dns_host_records,:identity]), :status => :ok
      }
    end
  end

  def show
    @user = User.accessible_by(current_ability).find params[:id]
    respond_to do |format|
      format.html
      format.json {
        respond_with @user.as_json(:include => [:dns_host_records,:identity])
      }
    end
  end

end
