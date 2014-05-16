class DnsZoneAaaaRecord < ActiveRecord::Base
  belongs_to :dns_zone_record
  
  validates :dns_zone_record_id, :presence => true
  
end
