class LocalUser 
  include User
  
  attr_accessor :first_name, :last_name, :email
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true, :unique => true
  validates :login_id, :presence => true, :unique => true

  def client_id
    nil
  end

end
