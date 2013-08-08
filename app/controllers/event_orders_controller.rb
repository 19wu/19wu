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
      render json: {result: 'ok', id: @order.id, link: pay_link(@order)}
    else
      render json: {result: 'errror'}
    end
  end

  def done

  end

  def notify

  end

  private

  def pay_link(order)
    event = order.event
    options = {
      :out_trade_no      => order.id,
      :subject           => "#{event.title} 门票",
      :logistics_type    => 'DIRECT',
      :logistics_fee     => '0',
      :logistics_payment => 'SELLER_PAY',
      :price             => order.price,
      :quantity          => 1,
      :discount          => 0,
      :return_url        => event_order_done_url(event, order), # localhost isn't work http://bit.ly/1cwKbsw
      :notify_url        => event_order_notify_url(event, order)
    }
    Alipay::Service.create_direct_pay_by_user_url(options)
  end
end
