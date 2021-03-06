class Ability
  include CanCan::Ability

  def initialize(user,request)
    @user = user
    @request = request

    if user.nil?
      return
    end

    if user.instance_of? Admin
      can :manage, Setting
      can :manage, Admin, :id => user.id
      can :manage, User
      can :destroy, DnsHostRecord
      can :destroy, DnsHostIpARecord
      can :destroy, DnsHostIpAaaaRecord
      can :read, DnsHostRecord
      can :read, DnsHostIpARecord
      can :read, DnsHostIpAaaaRecord
      can :read, DnsZone
    end

    if user.instance_of? ApiKey
      if user.user.nil? || !user.user.access_locked?
        can :setip, DnsHostRecord, :id => user.dns_entry.id
        can :read, DnsHostRecord, :id => user.dns_entry.id
        can :destroy, DnsHostRecord, :id => user.dns_entry.id
      end
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

    if user.instance_of?(User) && !user.access_locked? && user.email_verified?
      can :read, DnsZone, :is_public => true

      can :read, DnsHostRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :read, DnsHostIpARecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :read, DnsHostIpAaaaRecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }

      if user.dns_host_records.count < Setting.max_records.to_i
        can :create, DnsHostRecord, :dns_zone => {:is_public => true} 
        can :create, DnsHostIpARecord, :dns_host_record => { :dns_zone => {:is_public => true} }
        can :create, DnsHostIpAaaaRecord, :dns_host_record => { :dns_zone => {:is_public => true} }
      end

      can :edit, DnsHostRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :edit, DnsHostIpARecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :edit, DnsHostIpAaaaRecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      
      can :update, DnsHostRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :update, DnsHostIpARecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :update, DnsHostIpAaaaRecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      
      can :destroy, DnsHostRecord, :dns_zone => {:is_public => true}, :user_id => user.id.to_i
      can :destroy, DnsHostIpARecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }
      can :destroy, DnsHostIpAaaaRecord, :dns_host_record => { :dns_zone => {:is_public => true}, :user_id => user.id.to_i }

      can :manage, User, :id => user.id

    end

  end

end
