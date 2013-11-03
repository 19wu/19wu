class Admin::OrderFulfillmentsController < ApplicationController
  include HasApiResponse
  before_filter :authenticate_user!
  before_filter :authorize_order!

  def index
    @orders = EventOrder.where(status: 'paid').joins(items: :ticket).where(event_tickets: {require_invoice: true}).order('paid_amount_in_cents asc, id asc')
  end

  def create
    order = EventOrder.find(params[:order_id])
    @fulfillment = order.create_fulfillment!(params.fetch(:fulfillment).permit(:tracking_number))
  end

  private
  def authorize_order!
    authorize! :manage_fulfillment, EventOrder
  end
end
