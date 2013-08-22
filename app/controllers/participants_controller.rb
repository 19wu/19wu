class ParticipantsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!
  set_tab :check_in
  set_tab :participants_checkin, :sidebar, only: [:checkin]
  set_tab :participants_index  , :sidebar, only: [:index]

  def index
    @participants = @event.participants.joins(:user).order('users.login ASC').includes(:user => :profile)
  end

  def checkin
  end

  def update
    participant = @event.participants.where(checkin_code: params[:code]).first
    if participant
      participant.update_attribute :checkin_at, Time.now
    else
    end
    redirect_to event_participants_path
  end
end
