class IspDnszonesController < ApplicationController
  authorize_resource :class => IspDnszone

  def index
    @ispclient = current_user.client
    @ispdnszones = IspDnszone.dns_zone_get_by_user current_user,@ispclient.default_dnsserver
  end

end
