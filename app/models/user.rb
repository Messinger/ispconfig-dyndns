class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable
         
  has_many :dns_zone_records, :dependent => :destroy
  has_many :dns_zone_a_records, through: :dns_zone_records
  has_many :dns_zone_aaaa_records, through: :dns_zone_records
  
  def is_admin?
    false
  end
  
  def user_type
    UserHelper::USER_TYPE
  end

  def client_id
    nil
  end
  
end
