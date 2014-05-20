class DnsZone < ActiveRecord::Base
  has_many :dns_zone_records, :dependent => :destroy

  attr_accessor :name, :isp_dnszone_id, :isp_dnszone_origin, :isp_client_user_id

  validates :isp_dnszone_id, :presence => true, :uniqueness => true
  validates :isp_dnszone_origin, :presence => true, :uniqueness => true
  validates :isp_client_user_id, :presence => true
  validates :name, :presence => true, :uniqueness => true
  

  def ispdnszone=(ispdnszone)
      self.isp_dnszone_id = ispdnszone.id
      self.isp_dnszone_origin = ispdnszone.origin.dup
      self.isp_client_user_id = ispdnszone.sys_userid
      name = self.isp_dnszone_origin.dup
      while name.last == '.' do 
          name.chomp!('.')
      end
      self.name = name
      self
  end
  
  def ispdnszone
      @ispdnszone ||= IspDnszone.dns_zone_get self.isp_dnszone_id
  end

end
