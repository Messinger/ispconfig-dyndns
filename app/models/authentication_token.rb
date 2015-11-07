class AuthenticationToken < ActiveRecord::Base
  belongs_to :account, polymorphic: true

  validates :token, :uniqueness => true
  before_save :ensure_token

  def ensure_token
    if token.blank?
      self.token = generate_token
    end
  end

  def active_for_authentication?
    self.account.active_for_authentication?
  end

  private

  def generate_token
    loop do
      token = Devise.friendly_token
      break token unless AuthenticationToken.where(token: token).first
    end
  end

end
