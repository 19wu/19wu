class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!
  set_tab :check_in
  set_tab :checkin_code, :sidebar, only: [:qcode]
  set_tab :participants, :sidebar, only: [:index]

  def index
    @participants = @event.participants.joins(:user).order('users.login ASC').includes(:user => :profile)
  end

  def qcode
  end

  def update
    participant = @event.participants.find(params[:id])
    participant.joined = true
    participant.save

    redirect_to event_participants_path(@event), notice: I18n.t('flash.participants.checked_in', :name => participant.user.login)
  end

  private
  def authorize_event!
    @event = Event.find(params[:event_id])
    authorize! :update, @event
  end
end
