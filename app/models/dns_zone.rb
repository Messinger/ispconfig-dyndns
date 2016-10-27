class DnsZone < ActiveRecord::Base
  has_many :dns_host_records, :dependent => :destroy

  validates :isp_dnszone_id, :presence => true, :uniqueness => true
  validates :isp_dnszone_origin, :presence => true, :uniqueness => true
  validates :isp_client_user_id, :presence => true
  validates :name, :presence => true, :uniqueness => true

  def ispdnszone=(izone)
    self.isp_dnszone_id = izone.id
    Rails.logger.debug("#{izone.id} -> #{isp_dnszone_id}")
    self.isp_dnszone_origin = izone.origin.dup
    self.isp_client_user_id = izone.sys_userid
    _name = isp_dnszone_origin.dup
    while _name.last == '.' do 
        _name.chomp!('.')
    end
    self.name = _name
    self
  end


  def isp_dnszone
      @ispdnszone ||= IspDnszone.dns_zone_get self.isp_dnszone_id
  end

end
