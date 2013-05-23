class ParticipantsController < ApplicationController
  prepend_before_filter :authenticate_user!
  before_filter :authenticate_event_creator!
  set_tab :check_in

  def index
    @participants = @event.participants.joins(:user).order('users.login ASC').includes(:user => :profile)
  end

  def update
    participant = @event.participants.find(params[:id])
    participant.joined = true
    participant.save

    redirect_to event_participants_path(@event), notice: I18n.t('flash.participants.checked_in', :name => participant.user.login)
  end

  private
  def authenticate_event_creator!
    @event = Event.find(params[:event_id])
    authorize! :update, @event
  end
end
