class Ability
  include CanCan::Ability

  def initialize(user,request)
    @user = user
    @request = request

    if user.nil?
      return
    end

    if user.is_a? ClientUser
      can :manage,IspDnszone
      can :manage,IspDnsARecord
      can :manage,IspDnsAaaaRecord
      can :manage,IspResourceRecord
      
      can :read, DnsZone, :isp_client_user_id => user.id
      can :destroy, DnsZone, :isp_client_user_id => user.id
      can :add_dnszone, DnsZone
      
      #can :manage, DnsZone
    end

  end

end
