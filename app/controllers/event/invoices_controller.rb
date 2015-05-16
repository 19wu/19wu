class Event::InvoicesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!

  def index
    @orders = @event.orders.paid.joins(items: :ticket).where(event_tickets: {require_invoice: true}).order('paid_amount_in_cents asc, id asc')
  end
end
