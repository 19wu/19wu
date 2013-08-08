class EventOrdersController < ApplicationController
  before_filter :authenticate_user!

  def create
    @event = Event.find(params[:event_id]) # TODO: validate, event and its inventory
    @order = @event.orders.build user: current_user, event_id: @event.id
    params[:tickets].each do |ticket|
      event_ticket = @event.tickets.find(ticket[:id])
      @order.items.build ticket_id: ticket[:id], quantity: ticket[:quantity], price: (event_ticket.price * ticket[:quantity].to_i)
    end
    if @order.save
      render json: {result: 'ok'}
    else
      render json: {result: 'errror'}
    end
  end
end
