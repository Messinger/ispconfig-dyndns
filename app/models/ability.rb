class Ability
  include CanCan::Ability

  def initialize(user,request)
    @user = user
    @request = request

    alias_action :update_ip, :update_ipv6, :update_ipv4, :to => :change_ip

    if user.nil?
      return
    end

    if user.instance_of? ApiKey
      can :change_ip, DnsZoneRecord, :id => user.dns_zone_record.id
      can :read, DnsZoneRecord, :id => user.dns_zone_record
      can :destroy, DnsZoneRecord, :id => user.dns_zone_record
    end

    if user.instance_of? ClientUser
      can :manage,IspDnszone
      can :manage,IspDnsARecord
      can :manage,IspDnsAaaaRecord
      can :manage,IspResourceRecord

      can :read, DnsZone, :isp_client_user_id => user.id
      can :destroy, DnsZone, :isp_client_user_id => user.id
      can :update, DnsZone, :isp_client_user_id => user.id
      can :add_dnszone, DnsZone

      can :read, DnsZoneRecord, :dns_zone => {:isp_client_user_id => user.id.to_i}
      can :manage, DnsZoneRecord, :dns_zone => {:isp_client_user_id => user.id.to_i}, :user_id => nil

    end

    if user.instance_of? User
      can :read, DnsZone, :is_public => true

      can :read, DnsZoneRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :read, DnsZoneARecord, :dns_zone_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :read, DnsZoneAaaaRecord, :dns_zone_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }

      if user.dns_zone_records.count < Setting.max_records.to_i
        can :create, DnsZoneRecord, :dns_zone => {:is_public => true} 
        can :create, DnsZoneARecord, :dns_zone_record => { :dns_zone => {:is_public => true} }
        can :create, DnsZoneAaaaRecord, :dns_zone_record => { :dns_zone => {:is_public => true} }
      end

      can :edit, DnsZoneRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :edit, DnsZoneARecord, :dns_zone_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :edit, DnsZoneAaaaRecord, :dns_zone_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }

      can :destroy, DnsZoneRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :destroy, DnsZoneARecord, :dns_zone_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :destroy, DnsZoneAaaaRecord, :dns_zone_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }

    end

  end

end
