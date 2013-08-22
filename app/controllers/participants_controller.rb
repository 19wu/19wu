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
    @participant = @event.participants.where(checkin_code: params[:code]).first
    unless @participant
      render(json: { error: I18n.t('errors.messages.event_order_participant.invalid_code') }, status: 404) and return
    end
    @participant.update_attributes! checkin_at: Time.now
  end
end
