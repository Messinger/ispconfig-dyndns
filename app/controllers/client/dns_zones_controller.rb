class Client::DnsZonesController < ApplicationController
  authorize_resource :class => DnsZone
  
  def index
    Rails.logger.info "Dnszone index"
    @dns_zones = DnsZone.accessible_by(current_ability)
    index_bread
  end

  def show
    dnsid = params[:id]
    index_bread
    @dnszone = DnsZone.accessible_by(current_ability).find dnsid
    add_breadcrumb "Domainzone '#{@dnszone.name}'",client_dns_zone_path(@dnszone)
  end
  
  def add_dnszone
    ispzone_id = params[:ispzone_id]
    
    if ispzone_id.blank?
      raise BadRequest.new
    end
    
    ispzone = IspDnszone.dns_zone_get(ispzone_id)
    Rails.logger.info("#{ispzone.inspect} for #{current_user.inspect}")    

    if ispzone.nil? || !ispzone.instance_of?(IspDnszone)
      raise BadRequest.new
    end

    if ispzone.sys_userid != current_user.id
      raise NotFound.new
    end
    
    dnsz = DnsZone.new   
    dnsz.ispdnszone=ispzone
    
    if dnsz.valid? 
      dnsz.save
    end
    
    respond_to do |format|
      format.json {
        if dnsz.valid?
          render json: { :state => "Done"}, status: :ok
        else
          render json: { :state => "Could not save!"}, status: :bad_request
        end
      }
    end
  end

  def destroy
    zoneid = params[:id]
    
    dnsz = DnsZone.find zoneid
    
    dnszd = DnsZoneDecorator.new dnsz
    dnszd.cleanup_records
    dnsz.destroy

    respond_to do |format|
      format.json {
        render json: { :state => "Done"}, status: :ok
      }
    end
  end
  
  private
  
  def index_bread
    cu = ClientUserDecorator.new current_user
    
    add_breadcrumb "Local assigned domains for #{cu.full_name}",client_dns_zones_path
  end
  
end
