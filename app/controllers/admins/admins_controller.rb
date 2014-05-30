class Admins::AdminsController < ApplicationController
  authorize_resource :class => Admin

  def edit
    @admin = current_admin
    raise NotFound.new if @admin.nil?
    authorize! :edit, @admin
  end

  def update
  end

end
