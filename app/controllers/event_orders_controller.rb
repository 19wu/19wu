class EventOrdersController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :alipay_done]

  def create
    @event = Event.find(params[:event_id]) # TODO: validate, event and its inventory
    @order = @event.orders.build user: current_user, event_id: @event.id
    params[:tickets].each do |ticket|
      event_ticket = @event.tickets.find(ticket[:id])
      @order.items.build ticket_id: ticket[:id], quantity: ticket[:quantity], price: (event_ticket.price * ticket[:quantity].to_i)
    end
    if params[:user] # transaction
      current_user.update_attribute :phone, params[:user][:phone]
      current_user.profile.update_attribute :name, params[:user][:name]
    end
    if @order.save
      json = {result: 'ok', id: @order.id, status: @order.status}
      json[:link] = pay_link(@order) if @order.pending?
      render json: json
    else
      render json: {result: 'errror'}
    end
  end

  def alipay_done
    callback_params = params.except(*request.path_parameters.keys)
    if callback_params.any? && Alipay::Sign.verify?(callback_params) && params[:trade_status] == 'TRADE_SUCCESS'
      @order = current_user.orders.find params[:out_trade_no]
      @order.pay(params[:trade_no])
    end
  end

  def alipay_notify
    notify_params = params.except(*request.path_parameters.keys)
    if Alipay::Sign.verify?(notify_params) && Alipay::Notify.verify?(notify_params)
      @order = EventOrder.find params[:out_trade_no]
      if ['TRADE_SUCCESS', 'TRADE_FINISHED'].include?(params[:trade_status])
        @order.pay(params[:trade_no])
      # elsif params[:trade_status] == 'TRADE_CLOSED'
      #   @order.cancel
      end
      render text: 'success'
    else
      render text: 'fail'
    end
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
      :return_url        => event_order_alipay_done_url(event, order), # localhost isn't work http://bit.ly/1cwKbsw
      :notify_url        => event_order_alipay_notify_url(event, order)
    }
    Alipay::Service.create_direct_pay_by_user_url(options)
  end
end
