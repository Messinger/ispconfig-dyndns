class UsersController < ApplicationController
  before_action :set_user, :finish_signup
  skip_authorization_check :only => :finish_signup

  def finish_signup
    if (request.patch? || request.post?) && params[:user] #&& params[:user][:email]
      if current_user.update(user_params)
        current_user.skip_reconfirmation!
        sign_in(current_user, :bypass => true)
        if html_request?
          redirect_to current_user, notice: 'Your profile was successfully updated.'
        else
          render json: {account: current_account.as_json(include: [:unconfirmed_email]).merge({'type':current_account.class.name})}, status: :ok
        end
      else
        if html_request?
          @show_errors = true
        else
          render json: current_user.errors, status: 406
        end
      end
    else
      close_window and return unless json_request?
    end
  end

  def close_window
    render 'shared/close_window', status: :ok
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :name, :email ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end

