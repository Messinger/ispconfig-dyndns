class ApiKey < ActiveRecord::Base
  belongs_to :dns_entry, polymorphic: true

  validates :dns_entry, :presence => true
  validates :access_token, :uniqueness => true
  before_create :generate_access_token

  def user
    self.dns_entry.user
  end

  def active_for_authentication?
    self.user.nil? || self.user.active_for_authentication?
  end

private
  
  def generate_access_token
    begin
      t = Digest::MD5.hexdigest("#{DateTime.now}")
      self.access_token = t+SecureRandom.urlsafe_base64(8)
    end while self.class.exists?(access_token: access_token)
  end

end
