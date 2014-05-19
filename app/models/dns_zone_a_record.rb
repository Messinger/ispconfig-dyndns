class DnsZoneARecord < ActiveRecord::Base
  
  belongs_to :dns_zone_record
  
  validates :dns_zone_record_id, :presence => true

  def to_ispconfig_hash
    {
      :data => self.address
    }.merge self.dns_zone_record.to_ispconfig_hash
  end

  def self.ipmatch
    /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
  end
  
end
