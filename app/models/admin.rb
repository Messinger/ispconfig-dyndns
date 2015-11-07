class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :timeoutable, :lockable,
         :recoverable, :rememberable, :trackable, :authentication_keys => [:login],
         :reset_password_keys => [ :login ]

  has_one :authentication_token, as: :account, :dependent => :destroy

  validates :username, :uniqueness => { :case_sensitive => false }
  
  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def update_values(params,*options)
    current_password = params.delete(:current_password)
    new_password_error = false

    if params[:password].blank? ||  params[:password] != params[:password_confirmation] 
      if params[:password] != params[:password_confirmation]
        new_password_error = true
      end
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    Rails.logger.debug "Password #{current_password} is #{valid_password?(current_password)}"
    result = if valid_password?(current_password) && !new_password_error
      update_attributes(params, *options)
      Rails.logger.debug "Current values #{self.inspect}"
    else
      self.assign_attributes(params, *options)
      self.valid?
      if new_password_error
        self.errors.add(:password_confirmation,"must same as password")
      end
      if !valid_password?(current_password)
        self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      end
      false
    end

    self.password = nil
    self.password_confirmation = nil

    result

  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def as_json options={}
    _res = super options
    _res.merge!({
                    authentication_token: if authentication_token.blank?
                                            {}
                                          else
                                            authentication_token.as_json({:only => [:id,:token]})
                                          end
                }
    )
    _res
  end

end
