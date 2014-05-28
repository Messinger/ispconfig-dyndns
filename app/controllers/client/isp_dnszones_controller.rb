class Client::IspDnszonesController < ApplicationController
  authorize_resource :class => IspDnszone

  def index
    cu = ClientUserDecorator.new(current_client_user)
    @ispclient = cu.client
    @ispdnszones = IspDnszone.dns_zone_get_by_user cu,@ispclient.default_dnsserver
    add_breadcrumb "ISPConfig domains for #{cu.full_name}",client_isp_dnszones_path
  end

  def show
    @ispdnszone = IspDnszone.dns_zone_get params[:id]
    raise ForbiddenRequest.new if current_client_user.id != @ispdnszone.sys_userid
    cu = ClientUserDecorator.new current_client_user
    add_breadcrumb "ISPConfig domains for #{cu.full_name}",client_isp_dnszones_path
    add_breadcrumb @ispdnszone.origin,client_isp_dnszone_path(@ispdnszone)
  end

end
