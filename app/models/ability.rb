class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :create, Event if user.invitation_accepted?
    can :update, Event, :user_id => user.id
    can :manage, :all if user.admin?
  end
end
