class DnsHostRecordsController < ApplicationController
  authorize_resource :class => DnsHostRecord

  def index
    debug "DnszoneRecord index"

    zone_id = params[:zone_id]
    if zone_id.blank?
      @zone = nil
      @dns_host_records = DnsHostRecord.accessible_by(current_ability)
    else
      @zone = DnsZone.accessible_by(current_ability).find zone_id
      @dns_host_records = DnsHostRecord.accessible_by(current_ability).where(:dns_zone_id => @zone)
    end

    index_bread
  end

  def show
    recordid = params[:id]
    @dns_host_record = DnsHostRecord.accessible_by(current_ability).find recordid

    respond_to do |format|
      format.json {
        render :json => @dns_host_record.as_json({:simple => true}), :status => :ok
      }
      format.html {
      }
    end


  end

  def new
    dnszoneid=params[:dns_zone_id]
    
    if dnszoneid.blank?
      @dns_zone = nil
    else
      @dns_zone = DnsZone.accessible_by(current_ability).find dnszoneid
    end
    @dns_host_record = DnsHostRecord.new
    debug "New Record: #{@dns_host_record}"
    @dns_host_record.dns_zone_id = @dns_zone.id unless @dns_zone.nil?

    unless params[:partial].blank?
      render :partial => 'edit_record' and return
    else
      index_bread
      add_breadcrumb "New DNS Record",new_dns_host_record_path
    end
  end

  def create
    dns_host_record = DnsHostRecord.new
    # if ClientUser is logged in current user returns nil
    dns_host_record.user = current_user
    recparams = params[:dns_host_record]
    logger.error "Full params: #{params}"
    dns_zone_id = params[:dns_zone][:id]
    zone = DnsZone.accessible_by(current_ability).find dns_zone_id
    dns_host_record.dns_zone = zone
    dns_host_record.name = recparams[:name]
    saved = dns_host_record.save
    
    if saved
      recd = DnsHostRecordDecorator.new dns_host_record
      logger.debug "Parameter: #{recparams}"
      begin
        aaddr = params.has_key?("dns_zone_a_record") ? params[:dns_zone_a_record][:address]:""
        aaaaaddr = params.has_key?("dns_zone_aaaa_record") ? params[:dns_zone_aaaa_record][:address]:""
        if aaddr.blank? && aaaaaddr.blank?
          recd.address = request.remote_ip
        else
          recd.ipv4_address = aaddr.blank? ? nil:aaddr
          recd.ipv6_address = aaaaaddr.blank? ? nil:aaaaaddr
        end
        recd.update_remote
      rescue => ex
        logger.fatal ex
        saved = false
        recd.delete
      else
        recd.save
      end
    end
    
    respond_to do |format|
      format.json {
        if saved
          render :json => dns_host_record, :status => :ok, :location => dns_host_record_path(dns_host_record)
        else
          render :json => dns_host_record.errors, :status => :bad_request
        end
      }
    end
  end

  def destroy
    recordid = params[:id]
    dns_host_record = DnsHostRecord.accessible_by(current_ability).find recordid

    recd = DnsHostRecordDecorator.new dns_host_record
    recd.delete_remote
    del = recd.destroy
    if current_client_user
      back = client_dns_zone_path(dns_host_record.dns_zone)
    else
      back = root_path
    end

    respond_to do |format|
      format.json {
        render json: {"deleted" => recordid}, status: :ok
      }
      format.html {
        redirect_to back
      }
    end

  end

  private

  def index_bread

    if current_client_user
      cu = ClientUserDecorator.new current_client_user
      add_breadcrumb "Local domains for #{cu.full_name}",client_dns_zones_path
      add_breadcrumb "Local records for #{cu.full_name}",dns_host_records_path
    end

  end

end
