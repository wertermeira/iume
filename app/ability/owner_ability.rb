class OwnerAbility
  include CanCan::Ability

  def initialize(owner)
    can :manage, Restaurant, owner_id: owner.id
    can :manage, Section, restaurant: { owner_id: owner.id }
    can :manage, Product, section: { restaurant: { owner_id: owner.id } }
  end
end
