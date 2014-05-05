class IspClientUser < PresentationModel
  extend Ispremote::Soap
  include UserHelper::User
  
  attr_accessor :userid,:sys_userid, :sys_groupid, :sys_perm_user, :sys_perm_group, :sys_perm_other, :username, :passwort, :modules, :startmodule
  attr_accessor :app_theme, :typ, :active, :language, :groups, :default_group, :client_id, :id_rsa, :ssh_rsa
  
  operations :client_get_by_username

  def initialize data
    super data
    set_id self.userid
  end

  def self.client_get_by_username username
    asession = IspSession.login
    r = self.response_to_hash super(:message => {:sessionid => asession.sessionid, :username => username})
    raise ActiveRecord::RecordNotFound if r==false
    clientvalues = self.flatten_hash(r)
    IspClientUser.new clientvalues
  ensure 
    asession.logout
  end

  def self.find_by_username username
    client_get_by_username username
  end

  def password
    self.passwort
  end
  
  def authentication_token
    self.password
  end

end