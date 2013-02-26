class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :update, Event, :user_id => user.id
    can :manage, :all if user.admin?
  end
end
