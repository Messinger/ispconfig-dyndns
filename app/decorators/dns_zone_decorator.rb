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

  def as_json(options={})
    res = model.as_json(options)
    res[:assigned_records_count] = dns_host_records.count
    res
  end
end
