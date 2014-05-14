class User < ActiveRecord::Base
  include UserHelper::GeneralUser
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :login_id, :presence => true, :uniqueness => true
  validates :password, :presence => true
  validate  :unencrypted, :updated_user_password

  def client_id
    nil
  end

  def password=(unencrypted)
    enc = ( unencrypted.nil? ? nil : encrypt_password(unencrypted) )
    @unencrypted = unencrypted
    write_attribute(:password,enc)
  end
  
  def is_admin?
    false
  end


  private
  
  def unencrypted
    @unencrypted 
  end

  def updated_user_password
    # didn't make new password
    return if unencrypted.nil?
    if unencrypted.length < 8
      errors.add(:password,"Password is too short")
    end
  end

end
