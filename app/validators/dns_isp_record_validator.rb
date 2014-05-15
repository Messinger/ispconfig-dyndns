# validate new records against ISP Config DNS entries
class DnsIspRecordValidator <  ActiveModel::Validator
    
    def validate(record)
      if record.new_record? || record.name_changed? 
        return if record.name.nil? 
        recs = record.dns_zone.ispdnszone.find_record_by_name record.name
        if recs.length > 0
            record.errors[:base] << "This record name can not used"
        end
      end
    end

end
