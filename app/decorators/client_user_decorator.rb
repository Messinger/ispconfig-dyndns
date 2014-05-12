class ClientUserDecorator < ApplicationDecorator
  delegate_all

  def full_name
    model.login_id.capitalize
  end

end
