class DnsZone < ActiveRecord::Base
  has_many :dns_zone_records

  validates :isp_dnszone_id, :presence => true, :uniqueness => true
  validates :isp_dnszone_origin, :presence => true, :uniqueness => true
  validates :isp_client_user_id, :presence => true
  validates :name, :presence => true, :uniqueness => true

end
