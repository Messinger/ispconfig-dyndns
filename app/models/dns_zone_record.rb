class DnsZoneRecord < ActiveRecord::Base
  belongs_to :dns_zone
  belongs_to :user

  has_one :dns_zone_a_record
  has_one :dns_zone_aaaa_record

  validates :user_id, :presence => true
  validates :name, :presence => true

end
