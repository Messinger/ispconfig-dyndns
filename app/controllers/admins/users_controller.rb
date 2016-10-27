class Admins::UsersController < ApplicationController
  authorize_resource :class => User

  respond_to :json, :html

  def index
    @users = User.accessible_by(current_ability)

    respond_with @users

  end

  def show
    @user = User.accessible_by(current_ability).find params[:id]
    @user = {:user => @user.as_json,:domains => @user.dns_host_records}
    respond_with @user
  end

end
