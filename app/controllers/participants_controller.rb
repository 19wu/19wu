class ParticipantsController < ApplicationController
  prepend_before_filter :authenticate_user!

  def index
    @event = Event.find(params[:event_id])
    @participants = @event.participants.joins(:user).order('users.login ASC').includes(:user => :profile)
  end

  def update
    event = Event.find(params[:event_id])
    participant = event.participants.find(params[:id])
    participant.joined = true
    participant.save

    redirect_to event_participants_path(event), notice: I18n.t('flash.participants.checked_in', :name => participant.user.login)
  end
end
