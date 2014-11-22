require 'resolv'

class DnsZoneAaaaRecord < ActiveRecord::Base
  
  belongs_to :dns_host_record
  
  validates :dns_host_record_id, :presence => true
  validate :address, :validate_address

  def to_ispconfig_hash
    {
      :data => self.address
    }.merge self.dns_host_record.to_ispconfig_hash
  end

  def validate_address
    return if self.address.blank?
    
    if self.address.match(Resolv::IPv6::Regex).nil?
      errors.add(:address,"not a valid ipv6 address")
    end
    
  end

end
