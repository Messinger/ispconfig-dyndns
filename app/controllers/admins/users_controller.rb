class Admins::UsersController < ApplicationController
  authorize_resource :class => User

  respond_to :json, :html

  def index
    @users = User.accessible_by(current_ability)

    respond_with @users

#    respond_to do |format|
#      format.json {
#        render :json => @users.as_json, :status => :ok
#      }
#    end
  end

end

