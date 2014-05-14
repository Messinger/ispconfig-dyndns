class IspClient < PresentationModel
  extend Ispremote::Soap
  include UserHelper::GeneralUser
  
  operations :client_get

  def initialize data
    super data
    set_id client_id
  end

  def self.client_get aclientuser
    asession = IspSession.login
    if aclientuser.is_a? IspClientUser
      id = aclientuser.client_id
    else
      id = aclientuser
    end
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :client_id => id})
    raise ActiveRecord::RecordNotFound if r==false || !r.has_key?(:item)
    clientvalues = self.flatten_hash(r)
    IspClient.new clientvalues
  ensure 
    asession.logout unless asession.nil?
  end

end
