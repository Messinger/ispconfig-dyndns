class DnsZoneRecord < ActiveRecord::Base
  belongs_to :dns_zone
  belongs_to :user

  has_one :dns_zone_a_record, :dependent => :destroy
  has_one :dns_zone_aaaa_record, :dependent => :destroy
  has_one :api_key, as: :token_parent, :dependent => :destroy

  validates :user_id, :presence => true
  validates :name, :presence => true

  validates :name, uniqueness: {scope: :dns_zone, message: "Name is in use", case_sensitive: false }
  
  # validate against IPS Dns Records
  validates_with DnsIspRecordValidator


  after_create :create_assignees

  private

  def create_assignees
    self.api_key = ApiKey.new
    self.dns_zone_aaaa_record = DnsZoneAaaaRecord.new
    self.dns_zone_a_record = DnsZoneARecord.new
  end

end
