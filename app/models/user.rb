class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable,
         :omniauthable

  has_many :dns_host_records, :dependent => :destroy
  has_many :dns_host_ip_a_records, through: :dns_host_records
  has_many :dns_host_ip_aaaa_records, through: :dns_host_records
  has_one :identity, :dependent => :destroy
  has_one :authentication_token, as: :account, :dependent => :destroy
  
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
      user = if auth.info.email.blank?
               nil
             else
               User.find_by(:email => auth.info.email)
             end

      # Create the user if it's a new registration
      if user.nil?
        _n = nil
        unless auth.info.nil?
          if !auth.info.name.blank?
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
          email: auth.info.email.blank? ? "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com" : auth.info.email,
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

  def as_json options={}

    _opt = options.dup

    if _opt.key?(:include) && !_opt.key?(:force_except)
      enforce_except = BLACKLIST_FOR_SERIALIZATION.dup
      includes = _opt[:include].dup
      _opt[:include].each do |val|
        if enforce_except.find_index(val)
          includes.delete(val)
          enforce_except.delete(val)
        end
      end
      _opt[:force_except] = enforce_except
      _opt[:include] = includes
    end

    _res = super _opt

    _opt.delete(:include)
    if options.key?(:include)
      if (options[:include].is_a?(Symbol) && options[:include] == :identity)||(options[:include].is_a?(Array) && options[:include].include?(:identity))
        _res['identity'] = identity.as_json(:only => [:id,:provider,:uid])
      else
        _res['identity'] = {}
      end
    end
    _res['email_verified'] = email_verified?
    _res
  end

  def login_json options={}
    _opts = options.merge(:only => [:id,:email,:username])
    _res = as_json options
    _res.merge!({
                    authentication_token: if authentication_token.blank?
                                            nil
                                          else
                                            authentication_token.token
                                          end
                }
    )
    _res
  end

end
