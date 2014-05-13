module User

  attr_accessor :login_id, :password
  attr_accessor :first_name, :last_name, :email
  
  def admin?
    false
  end

end
