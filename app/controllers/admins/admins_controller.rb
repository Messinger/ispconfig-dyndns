class Admins::AdminsController < ApplicationController
  authorize_resource :class => Admin

  def edit
    @admin = Admin.find current_admin.id
    raise NotFound.new if @admin.nil?
    authorize! :edit, @admin
    resource = @admin
  end

  def update
    admin = Admin.find current_admin.id

    authorize! :edit, admin
    raise BadRequest.new unless params.has_key? :admin

    res = admin.update_values(admin_params)

    Rails.logger.debug("#{res} - #{admin.inspect}")

    if !res || !admin.valid?
      @admin = admin
      render 'edit' and return
    else
      sign_in "admin", admin, bypass: true
      redirect_to admin_root_path
    end

  end

  def resource
    @admin
  end

  private

  def admin_params
    accessible = [ :email, :current_password ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:admin][:password].blank?
    params.require(:admin).permit(accessible)
  end

end
