class EventOrdersController < ApplicationController
  include AlipayGeneratable
  before_filter :authenticate_user!, only: [:create, :alipay_done]

  def create
    @event = Event.find(params[:event_id]) # TODO: validate, event and its inventory
    @order = @event.orders.build user: current_user, event_id: @event.id
    params[:tickets].each do |ticket|
      event_ticket = @event.tickets.find(ticket[:id])
      @order.items.build ticket_id: ticket[:id], quantity: ticket[:quantity], price: (event_ticket.price * ticket[:quantity].to_i)
    end if params[:tickets]
    if params[:user] # transaction
      current_user.update_attribute :phone, params[:user][:phone]
      current_user.profile.update_attribute :name, params[:user][:name]
    end
    if @order.save
      json = {result: 'ok', id: @order.id, status: @order.status}
      json[:link] = generate_pay_link_by_order(@order) if @order.pending?
      render json: json
    else
      render json: {result: 'error', errors: @order.errors.full_messages.join(', ')}
    end
  end
end
