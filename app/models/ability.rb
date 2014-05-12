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
    end

  end

end
