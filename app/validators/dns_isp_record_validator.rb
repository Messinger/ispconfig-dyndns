# validate new records against ISP Config DNS entries
class DnsIspRecordValidator <  ActiveModel::Validator
    
    def validate(record)
      if record.new_record? || record.name_changed? || record.dns_zone_id_changed? 
        record.errors[:dnszone] << "Dnszone must selected" and return if record.dns_zone.nil?
        record.errors[:name] << "No record name set" and return if record.name.blank?
        recs = record.dns_zone.ispdnszone.find_record_by_name record.name
        if recs.length > 0
            record.errors[:name] << "This record name can not used"
        end
      end
    end

end
