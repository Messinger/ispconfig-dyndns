class Client::IspDnszonesController < ApplicationController
  authorize_resource :class => IspDnszone

  def index
    cu = ClientUserDecorator.new(current_user)
    @ispclient = cu.client
    @ispdnszones = IspDnszone.dns_zone_get_by_user cu,@ispclient.default_dnsserver
  end

  def show
    @ispdnszone = IspDnszone.dns_zone_get params[:id]
    raise ForbiddenRequest.new if current_user.id != @ispdnszone.sys_userid
  end

end
