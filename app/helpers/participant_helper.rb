module ParticipantHelper

  def participant_info(event, user)
    EventParticipant.where("event_id = ? and user_id = ?", event.id, user.id).first
  end

end
