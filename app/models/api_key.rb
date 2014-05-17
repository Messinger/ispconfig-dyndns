class ApiKey < ActiveRecord::Base
  belongs_to :token_parent, polymorphic: true

  validates :token_parent, :presence => true
  validates :access_token, :uniqueness => true
  before_create :generate_access_token
  
private
  
  def generate_access_token
    begin
      t = Digest::MD5.hexdigest("#{DateTime.now}")
      self.access_token = t+SecureRandom.urlsafe_base64(8)
    end while self.class.exists?(access_token: access_token)
  end

end