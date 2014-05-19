class DnsZoneAaaaRecord < ActiveRecord::Base
  
  belongs_to :dns_zone_record
  
  validates :dns_zone_record_id, :presence => true

  def to_ispconfig_hash
    {
      :data => self.address
    }.merge self.dns_zone_record.to_ispconfig_hash
  end

  def self.ipmatch
    /^([\da-fA-F]{1,4}:){7}([\da-fA-F]{1,4})$/
  end

end
