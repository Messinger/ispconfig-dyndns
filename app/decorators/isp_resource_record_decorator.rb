class IspResourceRecordDecorator < ApplicationDecorator
  delegate_all

  def localdns(dns_zone)
    @localdns ||= dns_zone.dns_host_records.find_by_name model.name unless dns_zone.blank?
  end

  def localdnsname(dns_zone)
    _r = if dns_zone.blank?
           nil
         else
           localdns(dns_zone)
         end
    return "" if _r.blank?
    _r.name
  end

  def table_hash
    @table_hash ||= retrieve_table_hash
  end

  def local_record_url(dns_zone)
    _r = if dns_zone.blank?
           nil
         else
           localdns(dns_zone)
         end
    return "" if _r.blank?
    h.link_to _r.name,h.dns_host_record_path(_r)
  end

  def as_json(options={})
    with_local = options.delete(:with_local)
    jres = super options
    if with_local
      jres[:local_host_rec] = {}
      if model.type == 'A'
        lrec = DnsHostIpARecord.find_by(isp_dns_a_record_id: model.id)
      elsif model.type == 'AAAA'
        lrec = DnsHostIpAaaaRecord.find_by(isp_dns_aaaa_record_id: model.id)
      else
        lrec = nil
      end
      unless lrec.blank?
        jres[:local_host_rec] = lrec.dns_host_record.as_json(include: [:dns_host_ip_a_record,:dns_host_ip_aaaa_record])
      end
    end
    jres
  end
  private

  def retrieve_table_hash
    {:name => model.name, :data => model.data, :type => model.type, :localrecord => local_record_url }
  end

end

