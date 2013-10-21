class ParticipantsController < ApplicationController
  include HasApiResponse
  before_filter :authenticate_user!
  before_filter :authorize_event!
  set_tab :check_in
  set_tab :participants_checkin, :sidebar, only: [:checkin]
  set_tab :participants_index  , :sidebar, only: [:index]

  rescue_from ActiveRecord::RecordNotFound, with: :render_record_no_found_error

  def index
    @participants = @event.participants.joins(:user).order('users.login ASC').includes(:user => :profile)
  end

  def export
    @orders = @event.orders.where(status: :paid).includes(:participant).order('event_order_participants.checkin_code')
  end

  def checkin
  end

  def update
    @participant = @event.participants.where(checkin_code: params[:code]).first!
    @participant.checkin!
  end

  private
  def render_record_no_found_error(exception)
    render json: { errors: [I18n.t('errors.messages.event_order_participant.invalid_code')] }, status: :not_found
  end
end
