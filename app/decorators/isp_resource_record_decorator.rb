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

  private

  def retrieve_table_hash
    {:name => model.name, :data => model.data, :type => model.type, :localdns => localdnsname }
  end

end

