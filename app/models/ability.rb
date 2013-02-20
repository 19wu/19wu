class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update, :destroy, :to => :modify

    can :show, Event

    unless user.blank?
      has_signed_in_ability
      can :modify, Event do |event|
        event.try(:user) == user
      end
    end
  end

  def has_signed_in_ability
    can :index, Event
    can :create, Event
    can :joined, Event
    can :join, Event
  end
end
