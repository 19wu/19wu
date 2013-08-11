module EventJoinHelper
  def joined?(event)
    !!(current_user && current_user.joined?(event))
  end
end
