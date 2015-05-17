class Event::InvoicesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!

  def index
    @orders = @event.orders.paid.where(require_invoice: true).includes(:items).order('paid_amount_in_cents asc, id asc')
  end
end
