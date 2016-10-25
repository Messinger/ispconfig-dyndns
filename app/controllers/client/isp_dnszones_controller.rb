class Client::IspDnszonesController < ApplicationController
  authorize_resource :class => IspDnszone

  def index
    cu = ClientUserDecorator.new(current_client_user)
    @ispclient = cu.client
    @ispdnszones = []
    @ispclient.dns_server_list.each do |dnsserver|
      @ispdnszones << IspDnszone.dns_zone_get_by_user(cu,dnsserver)
    end
    @ispdnszones.flatten!

    add_breadcrumb "ISPConfig domains for #{cu.full_name}",client_isp_dnszones_path
  end

  def show
    @ispdnszone = IspDnszoneDecorator.new(IspDnszone.dns_zone_get(params[:id]))
    raise ForbiddenRequest.new if current_client_user.id != @ispdnszone.sys_userid
    _records = @ispdnszone.records
    @ispdnszonerecords = IspResourceRecordDecorator.decorate_collection _records

    cu = ClientUserDecorator.new current_client_user
    add_breadcrumb "ISPConfig domains for #{cu.full_name}",client_isp_dnszones_path
    add_breadcrumb @ispdnszone.origin,client_isp_dnszone_path(@ispdnszone)
  end

end
