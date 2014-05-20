class Client::DnsZonesController < ApplicationController
  authorize_resource :class => DnsZone
  
  def index
    Rails.logger.info "Dnszone index"
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

end
