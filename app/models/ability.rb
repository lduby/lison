class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new # guest user (not logged in)
    # if user.role :admin
    #   can :manage, :all
    # elsif user.role :team
    #   can :manage, [ Item, ItemCopy, Membership, Event ]
    # elsif user.role :member
    #   can :read, [ Item, ItemCopy, Event ]
    #   can :read, Membership do | membership |
    #     membership.try( :member ) == user
    #   end
    #   # manage products, assets he owns
    #   can :manage, List do | list |
    #     list.try( :owner ) == user
    #   end
    #   can :manage, Shelf do | shelf |
    #     shelf.try( :owner ) == user
    #   end
    # end
  end
end
