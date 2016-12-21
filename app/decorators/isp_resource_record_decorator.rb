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

  private

  def retrieve_table_hash
    {:name => model.name, :data => model.data, :type => model.type, :localrecord => local_record_url }
  end

end

