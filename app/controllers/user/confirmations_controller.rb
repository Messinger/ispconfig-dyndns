class User::ConfirmationsController < Devise::ConfirmationsController

  def show
    super
  end

  protected

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    root_path
    #if signed_in?(resource_name)
    #  signed_in_root_path(resource)
    #else
    #  new_session_path(resource_name)
    #end
  end

end