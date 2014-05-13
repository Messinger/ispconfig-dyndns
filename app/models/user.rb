module User

  attr_accessor :login_id, :password
 
  def admin?
    false
  end

end
