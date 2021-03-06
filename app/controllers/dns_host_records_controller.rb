class DnsHostRecordsController < ApplicationController
  authorize_resource :class => DnsHostRecord

  protect_from_forgery except: :setip
  respond_to :json,:html

  def index
    debug "DnszoneRecord index"

    zone_id = params[:zone_id]
    dns_host_records = DnsHostRecord.accessible_by(current_ability)
    if zone_id.blank?
      @zone = nil
    else
      @zone = DnsZone.accessible_by(current_ability).find zone_id
      dns_host_records = dns_host_records.where(:dns_zone => @zone)
    end

    unless params[:user_id].blank?
      dns_host_records = dns_host_records.where(:user => User.accessible_by(current_ability).find(params[:user_id]))
    end

    @dns_host_records = DnsHostRecordDecorator.decorate_collection(dns_host_records)

    if html_request?
      index_bread
    end

    json_response = []

    if json_request?
      @dns_host_records.each do |record|
        rcj = record.as_json(simple: true)
        unless can?(:edit,record)
          rcj['api_key']['access_token'] = nil
        end
        rcj['full_name'] = record.full_name
        json_response << rcj
      end
    end

    respond_to do |format|
      format.html {
        respond_with @dns_host_records
      }
      format.json {
        render :json => json_response, :status => :ok
      }
    end
  end

  def edit
    recordid = params[:id]
    @dns_host_record = DnsHostRecord.accessible_by(current_ability).find(recordid)
    @dns_host_record = @dns_host_record.decorate
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
    unless can?(:edit,@dns_host_record)
      @dns_host_record.api_key.access_token=nil
    end

    show_bread

    show_bread

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

    @dns_host_record.dns_zone_id = @dns_zone.id unless @dns_zone.nil?

    if html_request?
      unless params[:partial].blank?
        render :partial => 'edit_record' and return
      else
        index_bread
        add_breadcrumb "New DNS Record",new_dns_host_record_path
      end
    else
      zones = DnsZone.accessible_by(current_ability)
      render :json => {record: @dns_host_record, zoneselection: zones }, status: :ok
    end


  end

  def update
    record = DnsHostRecord.find(params[:id]).decorate
    debug "Found record #{record}"
    
    debug "New values: #{params}"
    
    record.ipv4_address = params[:dns_host_ip_a_record][:address] unless params[:dns_host_ip_a_record].blank?
    record.ipv6_address = params[:dns_host_ip_aaaa_record][:address] unless params[:dns_host_ip_aaaa_record].blank?

    if current_client_user
      record.ttl = if params[:ttl].blank?
                              Setting.default_ttl
                            else
                              params[:ttl]
                            end
    else
      record.ttl = Setting.default_ttl
    end

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
    rec = DnsHostRecord.accessible_by(current_ability)
    raise BadRequest.new unless rec.size == 1

    rec = rec[0].decorate

    rec.check_update({:ipv4 => params[:ipv4], :ipv6 => params[:ipv6], :ip => params[:ip], :remote => request.remote_ip})
    debug rec

    if rec.changed?
      rec.update_remote
      rec.save
      stat = :ok
    else
      stat = :no_content
    end

    render :json => rec.as_json({:simple => true}), :status => stat, :location => dns_host_record_path(rec)
    
  end

  def create
    dns_host_record = DnsHostRecord.new
    # if ClientUser is logged in current user returns nil
    dns_host_record.user = current_user
    recparams = params[:dns_host_record]
    logger.debug "Full params: #{params}"
    if params.key? :dns_zone
      dns_zone_id = params[:dns_zone]
      if dns_zone_id.is_a? ActionController::Parameters
        dns_zone_id = dns_zone_id[:id]
      end
    else
      dns_zone_id = 0
    end

    zone = DnsZone.accessible_by(current_ability).find dns_zone_id
    dns_host_record.dns_zone = zone
    dns_host_record.name = recparams[:name]

    if current_client_user
      dns_host_record.ttl = if recparams[:ttl].blank?
                              Setting.default_ttl
                            else
                              recparams[:ttl]
                            end
    else
      dns_host_record.ttl = Setting.default_ttl
    end

    logger.debug "Parameter: #{recparams}"
    recd = DnsHostRecordDecorator.new dns_host_record
   
    if dns_host_record.valid? && dns_host_record.save
      saved = true
      aaddr = params.has_key?(:dns_host_ip_a_record) ? params[:dns_host_ip_a_record][:address]:""
      aaaaaddr = params.has_key?("dns_host_ip_aaaa_record") ? params[:dns_host_ip_aaaa_record][:address]:""
      if aaddr.blank? && aaaaaddr.blank?
        recd.address = request.remote_ip
      else
        recd.ipv4_address = aaddr.blank? ? nil:aaddr
        recd.ipv6_address = aaaaaddr.blank? ? nil:aaaaaddr
      end
      saved = false
      begin
        saved = recd.update_remote
      rescue => ex
        logger.fatal ex
        saved = false
      else
        saved = recd.save if saved
      end
      unless saved
        dns_host_record.delete
      end
    else 
      saved = false
    end
    
    respond_to do |format|
      format.json {
        if saved
          render :json => recd.as_json({:simple => true}), :status => :ok, :location => dns_host_record_path(recd)
        else
          render :json => recd.errors, :status => :bad_request
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
        render json: {:deleted => recordid}, status: :ok
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
