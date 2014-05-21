class Ability
  include CanCan::Ability

  def initialize(user,request)
    @user = user
    @request = request

    if user.nil?
      return
    end

    if user.instance_of? ClientUser
      can :manage,IspDnszone
      can :manage,IspDnsARecord
      can :manage,IspDnsAaaaRecord
      can :manage,IspResourceRecord
      
      can :read, DnsZone, :isp_client_user_id => user.id
      can :destroy, DnsZone, :isp_client_user_id => user.id
      can :add_dnszone, DnsZone

      can :read, DnsZoneRecord, :dns_zone => {:isp_client_user_id => user.id.to_i}
      can :edit, DnsZoneRecord, :dns_zone => {:isp_client_user_id => user.id.to_i}, :user_id => nil

    end

  end

end
