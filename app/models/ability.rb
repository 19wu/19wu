class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :create, Event if user.invitation_accepted? or user.collaborator?
    can :update, Event do |event|
      event.user_id == user.id or event.group.collaborator?(user)
    end
    can :manage, :all if user.admin?
  end
end
