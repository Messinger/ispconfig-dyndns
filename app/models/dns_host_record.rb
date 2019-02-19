class DnsHostRecord < ActiveRecord::Base
  belongs_to :dns_zone
  belongs_to :user

  has_one :dns_host_ip_a_record, :dependent => :destroy
  has_one :dns_host_ip_aaaa_record, :dependent => :destroy
  has_one :api_key, as: :dns_entry, :dependent => :destroy

  validates :name, :presence => true
  validates :dns_zone, :presence => true

  validates :name, uniqueness: {scope: :dns_zone, message: "Name is in use", case_sensitive: false }, :format => { :with => /\A[a-zA-Z0-9]{1}[-A-Za-z0-9]{0,61}[a-zA-Z0-9]{1}\z/ }
  
  # validate against ISP Dns Records
  validates_with DnsIspRecordValidator


  before_validation :create_assignees
  
  def isp_dnszone_id
    self.dns_zone.isp_dnszone_id
  end
  
  def isp_dnszone
    self.dns_zone.isp_dnszone
  end

  def to_ispconfig_hash
    {
      :zone => self.dns_zone.isp_dnszone_id,
      :name => self.name,
      :ttl => self.ttl
    }
  end

  def as_json(options={})
    simple = options[:simple]

    unless simple.nil?
      options = options.merge({:only=>[:name,:id],
                               :include => {
                                            :dns_host_ip_a_record => {:only => [:address]},
                                            :dns_host_ip_aaaa_record=> {:only => [:address]},
                                            :api_key => {:only => [:access_token]},
                                            :dns_zone => {:only => [:name,:id]}
                                            }
                              })
    else
      options = options.merge({:include => [:dns_host_ip_a_record,:dns_host_ip_aaaa_record,:api_key,:dns_zone]})
    end
    super(options)
  end

  def self.find_by_name_and_ispzone_id name,ispzoneid
    dhzone = DnsZone.arel_table
    dhrecord = DnsHostRecord.arel_table
    _zone = dhzone[:isp_dnszone_id].eq(ispzoneid)
    _rec = dhrecord[:name].eq(name)
    DnsHostRecord.where(_rec.and(dhrecord[:dns_zone_id].in(DnsZone.where(_zone).ids))).to_a.first
  end

  private

  def create_assignees
    if new_record?
      self.api_key = ApiKey.new
      self.dns_host_ip_aaaa_record = DnsHostIpAaaaRecord.new
      self.dns_host_ip_a_record = DnsHostIpARecord.new
    end
  end

end
