class IspResourceRecordDecorator < ApplicationDecorator
  delegate_all

  def localdns
    @localdns ||= DnsHostRecord.find_by_name model.name
  end

  def localdnsname
    return "" if localdns.blank?
    localdns.name
  end

  def table_hash
    @table_hash ||= retrieve_table_hash
  end

  def local_record_url
    _r = localdns
    return "" if _r.blank?
    h.link_to _r.name,h.dns_host_record_path(_r)
  end

  private

  def retrieve_table_hash
    {:name => model.name, :data => model.data, :type => model.type, :localrecord => local_record_url }
  end

end

