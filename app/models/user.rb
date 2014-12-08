class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable,
         :omniauthable

  has_many :dns_host_records, :dependent => :destroy
  has_many :dns_host_a_records, through: :dns_host_records
  has_many :dns_host_aaaa_records, through: :dns_host_records
  has_one :identity, :dependent => :destroy
  
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update  
  
  def is_admin?
    false
  end
  
  def user_type
    UserHelper::USER_TYPE
  end

  def client_id
    nil
  end
 
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    Logging.logger["User"].debug("Auth raw_info: #{auth.extra.raw_info.inspect}")
    Logging.logger["User"].debug("Auth info: #{auth.info.inspect}")

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = !auth.info.email.blank? # && (auth.info.verified || auth.info.verified_email || auth.extra.raw_info.email_verified)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        _n = nil
        if  !auth.info.nil?
          if  !auth.info.name.blank?
            _n = auth.info.name
          elsif !auth.info.nickname.blank?
            _n = auth.info.nickname
          end
        end
        if _n.nil?
          _n = auth.raw_info.name
          if _n.blank? && !auth.raw_info.nickname.blank?
            _n = auth.raw_info.nickname
          end
        end
        if _n.nil?
          _n = ""
        end
        user = User.new(
          name: _n,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def send_reset_password_instructions
    Rails.logger.debug "Send reset passwords: #{self}"
    unless self.identity.nil?
      self.clear_reset_password_token
      self.save(validate: false)
      errors[:email] << "Password reset not possible for this email"
      return "Not possible!"
    end
    super
  end

  
end
