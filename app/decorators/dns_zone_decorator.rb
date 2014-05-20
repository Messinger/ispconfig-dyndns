class DnsZoneDecorator < ApplicationDecorator
  delegate_all
  
  def cleanup_records
    recs = dns_zone_records
    recs.each do |record|
      recd = DnsZoneRecordDecorator.new record
      recd.delete_remote
      recd.save
    end
  end

end
