class ClientUserDecorator < ApplicationDecorator
  delegate_all

  def full_name
    model.login_id.capitalize
  end

  def client
    IspClient.client_get client_id
  end
end
