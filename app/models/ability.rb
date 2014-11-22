class Ability
  include CanCan::Ability

  def initialize(user,request)
    @user = user
    @request = request

    alias_action :update_ip, :update_ipv6, :update_ipv4, :to => :change_ip

    if user.nil?
      return
    end

    if user.instance_of? Admin
      can :manage, Setting
      can :manage, Admin, :id => user.id
      can :manage, User
    end

    if user.instance_of? ApiKey
      can :change_ip, DnsHostRecord, :id => user.dns_host_record.id
      can :read, DnsHostRecord, :id => user.dns_host_record
      can :destroy, DnsHostRecord, :id => user.dns_host_record
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

      can :read, DnsHostRecord, :dns_zone => {:isp_client_user_id => user.id.to_i}
      can :manage, DnsHostRecord, :dns_zone => {:isp_client_user_id => user.id.to_i}, :user_id => nil

    end

    if user.instance_of? User
      can :read, DnsZone, :is_public => true

      can :read, DnsHostRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :read, DnsHostARecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :read, DnsZoneAaaaRecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }

      if user.dns_host_records.count < Setting.max_records.to_i
        can :create, DnsHostRecord, :dns_zone => {:is_public => true} 
        can :create, DnsHostARecord, :dns_host_record => { :dns_zone => {:is_public => true} }
        can :create, DnsZoneAaaaRecord, :dns_host_record => { :dns_zone => {:is_public => true} }
      end

      can :edit, DnsHostRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :edit, DnsHostARecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :edit, DnsZoneAaaaRecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }

      can :destroy, DnsHostRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :destroy, DnsHostARecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :destroy, DnsZoneAaaaRecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }

    end

  end

end
