class Admin::OrderFulfillmentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_order!

  def index
    @orders = EventOrder.where(status: 'paid').joins(items: :ticket).where(event_tickets: {require_invoice: true})
  end

  def create
  end

  private
  def authorize_order!
    authorize! :manage_invoice, EventOrder
  end
end
