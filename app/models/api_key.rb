class ApiKey < ActiveRecord::Base
  belongs_to :dns_host_record

  validates :dns_host_record, :presence => true
  validates :access_token, :uniqueness => true
  before_create :generate_access_token

  has_one :user, :through => :dns_host_record

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
