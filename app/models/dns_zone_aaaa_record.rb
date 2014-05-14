class DnsZoneAaaaRecord < ActiveRecord::Base
  belongs_to :dns_zone
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :name, :presence => true
  
end
