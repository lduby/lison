class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.role?('Member')
      # can :read, [ Item, ItemCopy, Event ]
      can :read, [ Item,  Author, Illustrator, Publisher, Collection, Theme ]
      can :list, [ Item, Collection ]
      # can :read, Membership do | membership |
      #   membership.try( :member ) == user
      # end
      # # manage products, assets he owns
      # can :manage, List do | list |
      #   list.try( :owner ) == user
      # end
      # can :manage, Shelf do | shelf |
      #   shelf.try( :owner ) == user
      # end
    elsif user.role?('Team')
      # can :manage, [ Item, ItemCopy, Membership, Event ]
      # can :crud, Collection
      # can :read, Collection
      # can :create, Collection
      can :crud, [ Item, Author, Illustrator, Publisher, Collection, Theme ]
      can :list, [ Item,  Collection ]

      # can :manage, [ Item, Author, Illustrator, Publisher, Collection ]

    elsif user.role?('Admin')
      can :manage, :all
    # else
    end
  end
end
