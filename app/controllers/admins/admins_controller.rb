class Admins::AdminsController < ApplicationController
  authorize_resource :class => Admin

  def edit
    @admin = current_admin
    raise NotFound.new if @admin.nil?
    authorize! :edit, @admin
    resource = @admin
  end

  def update
    @admin = current_admin
    raise NotFound.new if @admin.nil?
    authorize! :edit, @admin
    raise BadRequest.new unless params.has_key? :admin

    @admin.update_with_password admin_params

    if !@admin.valid?
      render 'edit' and return
    end

    redirect_to admin_edit_path

  end

  def resource
    @admin
  end

  private

  def admin_params
    params.require(:admin).permit(:email, :password, :current_password, :password_confirmation)
  end

end
