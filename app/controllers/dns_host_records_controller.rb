class DnsHostRecordsController < ApplicationController
  authorize_resource :class => DnsHostRecord

  def index
    debug "DnszoneRecord index"

    zone_id = params[:zone_id]
    if zone_id.blank?
      @zone = nil
      @dns_host_records = DnsHostRecordDecorator.decorate_collection(DnsHostRecord.accessible_by(current_ability))
    else
      @zone = DnsZone.accessible_by(current_ability).find zone_id
      @dns_host_records = DnsHostRecordDecorator.decorate_collection(DnsHostRecord.accessible_by(current_ability).where(:dns_zone_id => @zone))
    end

    index_bread
  end

  def edit
    recordid = params[:id]
    @dns_host_record = DnsHostRecord.accessible_by(current_ability).find(recordid)
    @dns_host_record = @dns_host_record.decorate
    debug("Edit #{@dns_host_record}")
    respond_to do |format|
      format.json {
        render :json => @dns_host_record.as_json({:simple => true}), :status => :ok
      }
      format.html {
        unless params[:partial].blank?
          render :partial => 'edit_record' and return
        else
          edit_bread
        end
      }
    end
  end
  
  def show
    recordid = params[:id]
    @dns_host_record = DnsHostRecord.accessible_by(current_ability).find(recordid).decorate

    respond_to do |format|
      format.json {
        render :json => @dns_host_record.as_json({:simple => true}), :status => :ok
      }
      format.html {
        show_bread
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

  def update
    record = DnsHostRecord.find(params[:id]).decorate
    debug "Found record #{record}"
    
    debug "New values: #{params}"
    
    record.ipv4_address = params[:dns_host_a_record][:address] unless params[:dns_host_a_record].blank?
    record.ipv6_address = params[:dns_host_aaaa_record][:address] unless params[:dns_host_aaaa_record].blank?

    saved = false
    
    if record.update_remote
      saved = record.save
    end
      
    respond_to do |format|
      format.json {
        if saved
          render :json => record.as_json({:simple => true}), :status => :ok, :location => dns_host_record_path(record)
        else
          render :json => record.errors, :status => :bad_request
        end
      }
    end
  end
 
  def setip
    access_token = params[:accesstoken]
    rec = DnsHostRecord.accessible_by(current_ability)
    raise BadRequest.new unless rec.size == 1

    rec = rec[0].decorate
    ipv4 = params[:ipv4]
    ipv6 = params[:ipv6]
    ip = params[:ip]
    remoteip = request.remote_ip

    data = {:ipv4 => ipv4, :ipv6 => ipv6, :ip => ip, :remote => remoteip}
    rec.check_update data
    debug rec

    if rec.changed?
      rec.update_remote
      rec.save
      stat = :ok
    else
      stat = :not_modified
    end

    render :json => rec.as_json({:simple => true}), :status => stat, :location => dns_host_record_path(rec)
    
  end

  def create
    dns_host_record = DnsHostRecord.new
    # if ClientUser is logged in current user returns nil
    dns_host_record.user = current_user
    recparams = params[:dns_host_record]
    logger.debug "Full params: #{params}"
    dns_zone_id = params[:dns_zone][:id]
    zone = DnsZone.accessible_by(current_ability).find dns_zone_id
    dns_host_record.dns_zone = zone
    dns_host_record.name = recparams[:name]
    saved = dns_host_record.save
    
    if saved
      recd = DnsHostRecordDecorator.new dns_host_record
      logger.debug "Parameter: #{recparams}"
      begin
        aaddr = params.has_key?("dns_host_a_record") ? params[:dns_host_a_record][:address]:""
        aaaaaddr = params.has_key?("dns_host_aaaa_record") ? params[:dns_host_aaaa_record][:address]:""
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
    recd = DnsHostRecord.accessible_by(current_ability).find(recordid).decorate

    recd.delete_remote
    del = recd.destroy
    if current_client_user
      back = client_dns_zone_path(recd.dns_zone)
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

  def show_bread
    index_bread
    add_breadcrumb "Details about #{@dns_host_record.full_name}", dns_host_record_path(@dns_host_record)
  end

  def edit_bread
    show_bread
    add_breadcrumb "Edit #{@dns_host_record.full_name}", edit_dns_host_record_path(@dns_host_record)
  end
end
