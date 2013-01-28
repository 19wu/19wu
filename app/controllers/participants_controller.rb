class ParticipantsController < ApplicationController
  prepend_before_filter :authenticate_user!

  def index
    @event = Event.find(params[:event_id])
    @users = User.where(:id => EventParticipant.select(:user_id).where("event_id = ?", params[:event_id])).order("login ASC")
  end

  def update
    event = Event.find(params[:event_id])
    participant = event.participants.find(params[:id])
    participant.joined = true
    participant.save

    redirect_to event_participants_path(event), notice: I18n.t('flash.participants.checked_in', :name => participant.user.login)
  end
end
