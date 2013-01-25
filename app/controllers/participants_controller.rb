class ParticipantsController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
    @users = @event.participants.map(&:user)
  end
end
