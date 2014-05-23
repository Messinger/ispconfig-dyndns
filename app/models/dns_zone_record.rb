class DnsZoneRecord < ActiveRecord::Base
  belongs_to :dns_zone
  belongs_to :user

  has_one :dns_zone_a_record, :dependent => :destroy
  has_one :dns_zone_aaaa_record, :dependent => :destroy
  has_one :api_key, as: :token_parent, :dependent => :destroy

  validates :name, :presence => true
  validates :dns_zone, :presence => true

  validates :name, uniqueness: {scope: :dns_zone, message: "Name is in use", case_sensitive: false }, :format => { :with => /\A[a-zA-Z0-9]{1}[-A-Za-z0-9]{0,61}[a-zA-Z0-9]{1}\z/ }
  
  # validate against ISP Dns Records
  validates_with DnsIspRecordValidator


  after_create :create_assignees
  
  def isp_dnszone_id
    self.dns_zone.isp_dnszone_id
  end
  
  def isp_dnszone
    self.dns_zone.isp_dnszone
  end

  def to_ispconfig_hash
    {
      :zone => self.dns_zone.isp_dnszone_id,
      :name => self.name
    }
  end

  def as_json(options={})
    super(:include => [:dns_zone_a_record,:dns_zone_aaaa_record,:api_key])
  end

  private

  def create_assignees
    self.api_key = ApiKey.new
    self.dns_zone_aaaa_record = DnsZoneAaaaRecord.new
    self.dns_zone_a_record = DnsZoneARecord.new
  end

end
