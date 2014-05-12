class IspDnszonesController < ApplicationController
  authorize_resource :class => IspDnszone

  def index
    @ispclient = current_user.client
    @ispdnszones = IspDnszone.dns_zone_get_by_user current_user,@ispclient.default_dnsserver
  end

  def show
      @ispdnszone = IspDnszone.dns_zone_get params[:id]
      raise ForbiddenRequest.new if current_user.id != @ispdnszone.sys_userid
  end
  
end
