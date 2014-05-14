class User < ActiveRecord::Base
  include UserHelper::GeneralUser
  
  before_validation :check_active
  
  attr_accessible :first_name, :last_name, :email, :login_id, :password, :active
  
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
    enc = ( unencrypted.blank? ? nil : encrypt_password(unencrypted) )
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
    return if unencrypted.blank?
    if unencrypted.length < 8
      errors.add(:password,"Password is too short")
    end
  end
  
  def check_active
    self.active = false if self.active.nil?
  end

end
