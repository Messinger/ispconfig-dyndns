# validate new records against ISP Config DNS entries
class DnsIspRecordValidator <  ActiveModel::Validator
  # noinspection RubyResolve
  def validate(record)
    return if record.errors.count > 0
    if record.new_record? || record.name_changed? || record.dns_zone_id_changed?
      record.errors[:dnszone] << 'Dnszone must selected' and return if record.dns_zone.nil?
      record.errors[:name] << 'No record name set' and return if record.name.blank?
      recs = record.dns_zone.isp_dnszone.find_record_by_name record.name
      if recs.length > 0
        irecaid= record.dns_host_ip_a_record.isp_dns_a_record_id.to_s
        irecaaaaid = record.dns_host_ip_aaaa_record.isp_dns_aaaa_record_id.to_s
        aaaarecords = recs.find_all {|rec| rec.instance_of?(IspDnsAaaaRecord) && rec.id == irecaaaaid}
        arecords = recs.find_all {|rec| rec.instance_of?(IspDnsARecord) && rec.id == irecaid}
        if aaaarecords.length == 0 && arecords.length == 0
          record.errors[:name] << 'This record name is in use'
        end
      end
    end
  end

end
