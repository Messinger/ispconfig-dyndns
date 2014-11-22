class DnsZoneDecorator < ApplicationDecorator
  delegate_all
  
  def cleanup_records
    recs = dns_host_records
    recs.each do |record|
      recd = DnsHostRecordDecorator.new record
      recd.delete_remote
      recd.save
    end
  end

end
