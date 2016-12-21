class IspDnszoneDecorator < ApplicationDecorator
  delegate_all

  def dns_zone
    if @zonechecked
      @dns_zone
    else
      @zonechecked = true
      @dns_zone ||= DnsZone.find_by(:isp_dnszone_id => model.id)
    end
  end
end

