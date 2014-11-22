class Admins::UsersController < ApplicationController
  authorize_resource :class => User

  def index
    @users = User.accessible_by(current_ability)
  end

end

