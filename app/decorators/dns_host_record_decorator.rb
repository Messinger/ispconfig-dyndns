require 'resolv'

class DnsHostRecordDecorator < ApplicationDecorator
  delegate_all

  def access_token
    self.api_key.access_token
  end
  
  def renew_token
    self.api_key = ApiKey.new
  end

  def ipv6_address
    self.dns_zone_aaaa_record.address
  end
  
  def ipv4_address
    self.dns_host_a_record.address
  end

  def ipv6_address= (address)
    self.dns_zone_aaaa_record.address = address
  end

  def ipv4_address= (address)
    self.dns_host_a_record.address = address
  end

  def empty?
    self.dns_host_a_record.address.blank? && self.dns_zone_aaaa_record.address.blank?
  end
  
  def full_name
    self.name+"."+self.dns_zone.name
  end
  
  def address=(address)
    
    case address
    when Resolv::IPv4::Regex
      self.ipv4_address=address
      self.ipv6_address=nil
    when Resolv::IPv6::Regex
      self.ipv6_address=address
      self.ipv4_address=nil
    else
      logger.error("#{address} is not a valid ip")
    end

  end
  
  def changed?
    model.changed? || self.dns_host_a_record.changed? || self.dns_zone_aaaa_record.changed?
  end

  def valid?
    model.valid? && self.dns_host_a_record.valid? && self.dns_zone_aaaa_record.valid?
  end
  
  def address_errors
    {:dns_zone_record => model.errors, :dns_zone_record_a_record => self.dns_host_a_record.errors, :dns_zone_record_aaaa_record => self.dns_zone_aaaa_record.errors }    
  end

  def errors
    return self.dns_host_a_record.errors unless self.dns_host_a_record.valid?
    return self.dns_zone_aaaa_record.errors unless self.dns_zone_aaaa_record.valid?
    model.errors
  end
  
  # always call BEFORE save!
  def update_remote
    return false if !valid?
    return true unless changed?
    
    logger.debug("Update remote")
    ispsession = IspSession.login
    
    isp_client = IspClient.client_for_user(dns_zone.isp_client_user_id,ispsession)
    arec = self.dns_host_a_record
    aaaarec = self.dns_zone_aaaa_record
    
    resa = true
    if arec.address_changed? || model.name_changed?
      isprecid = arec.isp_dns_a_record_id
      isprec = IspDnsARecord.dns_a_get(isprecid,ispsession) unless isprecid.blank?
      if arec.address.blank?
        unless isprecid.nil?
          logger.debug("Delete #{arec} remote")
          isprec = IspDnsARecord.dns_a_get(isprecid,ispsession)
          resa = isprec.dns_a_delete
          arec.isp_dns_a_record_id = nil
        end
      else
        if isprecid.nil?
          resa = IspDnsARecord.dns_a_add(arec,isp_client,ispsession)
          arec.isp_dns_a_record_id = resa.to_i
        else
          resa = isprec.dns_a_update(arec,isp_client,ispsession)
        end
      end
      arec.lastset = Time.now
    end
    
    resb = true
    if aaaarec.address_changed? || model.name_changed?
      isprecid = aaaarec.isp_dns_aaaa_record_id
      isprec = IspDnsAaaaRecord.dns_aaaa_get(isprecid,ispsession) unless isprecid.blank?
      if aaaarec.address.blank?
        unless isprecid.nil?
          isprec = IspDnsAaaaRecord.dns_aaaa_get(isprecid,ispsession)
          resb = isprec.dns_aaaa_delete
          aaaarec.isp_dns_aaaa_record_id = nil
        end
      else
        if isprecid.nil?
          resb = IspDnsAaaaRecord.dns_aaaa_add(aaaarec,isp_client,ispsession)
          aaaarec.isp_dns_aaaa_record_id = resb.to_i
        else
          resb = isprec.dns_aaaa_update(aaaarec,isp_client,ispsession)
        end
      end
      aaaarec.lastset = Time.now      
    end
    
    isp_zone_id = dns_zone.isp_dnszone_id
    
    unless isp_zone_id.blank?
      isp_zone = IspDnszone.dns_zone_get isp_zone_id,ispsession
      isp_zone.update_serial_number isp_client,ispsession
    end
    
    [arec,aaaarec]
  ensure
    ispsession.logout unless ispsession.nil?  
  end
    
  def delete_remote
    self.ipv6_address = nil
    self.ipv4_address = nil
    self.update_remote
  end

  # before save you must call update_remote!
  def save
    return false if !valid?
    return false if !model.save(:validate => false)
    return false if !self.dns_host_a_record.save(:validate => false)
    return false if !self.dns_zone_aaaa_record.save(:validate => false)
    return true
  end

end
