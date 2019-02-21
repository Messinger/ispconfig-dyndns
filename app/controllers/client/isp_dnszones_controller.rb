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

    add_breadcrumb "ISPConfig domains for #{cu.full_name}",client_isp_dnszones_path if html_request?

    if json_request?
      @ispdnszones = @ispdnszones.as_json
      @ispdnszones.each do |zone|
        zone[:local_zone] = DnsZone.find_by(:isp_dnszone_id =>zone['id']).as_json(:only => [:id,:name])||{id: nil, name: nil }
      end
    end

    respond_to do |format|
      format.json {
        render json: @ispdnszones.as_json, :status => :ok
      }
      format.html
    end

  end

  def show
    @ispdnszone = IspDnszoneDecorator.new(IspDnszone.dns_zone_get(params[:id]))
    raise ForbiddenRequest.new if current_client_user.id != @ispdnszone.sys_userid
    _records = @ispdnszone.records
    @ispdnszonerecords = IspResourceRecordDecorator.decorate_collection _records

    if html_request?
      cu = ClientUserDecorator.new current_client_user
      add_breadcrumb "ISPConfig domains for #{cu.full_name}",client_isp_dnszones_path
      add_breadcrumb @ispdnszone.origin,client_isp_dnszone_path(@ispdnszone)
    end

    respond_to do |format|
      format.html
      format.json {
        render json: {zone: @ispdnszone.as_json, records: @ispdnszonerecords.as_json({:with_local => true})}, status: :ok
      }
    end

  end

end
