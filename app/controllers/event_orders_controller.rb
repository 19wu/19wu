class EventOrdersController < ApplicationController
  include AlipayGeneratable
  before_filter :authenticate_user!, only: [:create, :alipay_done]

  def create
    @event = Event.find(params[:event_id]) # TODO: validate, event and its inventory
    @order = @event.orders.build user: current_user, event_id: @event.id
    params[:tickets].each do |ticket|
      event_ticket = @event.tickets.find(ticket[:id])
      @order.items.build ticket_id: ticket[:id], quantity: ticket[:quantity], price: (event_ticket.price * ticket[:quantity].to_i)
    end
    if @order.save
      json = {result: 'ok', id: @order.id, status: @order.status}
      json[:link] = generate_pay_link_by_order(@order) if @order.pending?
      render json: json
    else
      render json: {result: 'error'}
    end
  end
end
