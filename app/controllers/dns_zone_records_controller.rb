class DnsZoneRecordsController < ApplicationController
  authorize_resource :class => DnsZoneRecord

  def index
    Rails.logger.info "DnszoneRecord index"

    zone_id = params[:zone_id]
    if zone_id.blank?
      @zone = nil
      @dns_zone_records = DnsZoneRecord.accessible_by(current_ability)
    else
      @zone = DnsZone.accessible_by(current_ability).find zone_id
      @dns_zone_records = DnsZoneRecord.accessible_by(current_ability).where(:dns_zone_id => @zone)
    end

    index_bread
  end

  def new
    dnszoneid=params[:dns_zone_id]
    
    if dnszoneid.blank?
      @dns_zone = nil
    else
      @dns_zone = DnsZone.accessible_by(current_ability).find dnszoneid
    end
    @dns_zone_record = DnsZoneRecord.new
    @dns_zone_record.dns_zone_id = @dns_zone.id unless @dns_zone.nil?

    unless params[:partial].blank?
      render :partial => 'edit_record' and return
    else
      index_bread
      add_breadcrumb "New DNS Record",new_dns_zone_record_path
    end
  end

  private

  def index_bread

    if current_user.instance_of? ClientUser
      cu = ClientUserDecorator.new current_user
      add_breadcrumb "Local domains for #{cu.full_name}",client_dns_zones_path
      add_breadcrumb "Local records for #{cu.full_name}",dns_zone_records_path
    end

  end

end
