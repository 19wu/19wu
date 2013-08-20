class UserOrdersController < ApplicationController
  include AlipayGeneratable
  before_filter :authenticate_user!

  def index
    @orders = current_user.orders.includes(items: :ticket)
  end

  def pay
    order = current_user.orders.find params[:id]

    if order.pending?
      redirect_to generate_pay_link_by_order(order)
    else
      redirect_back_or user_orders_path
    end
  end

  def request_refund
    order = current_user.orders.find params[:id]

    order.request_refund!
    redirect_back_or user_orders_path, notice: t('flash.my_orders.request_refund')
  end

  def cancel
    order = current_user.orders.find params[:id]

    order.cancel!
    redirect_to user_orders_path, notice: t('flash.my_orders.canceled')
  end

  def alipay_done
    callback_params = params.except(*request.path_parameters.keys)
    if callback_params.any? && Alipay::Sign.verify?(callback_params) && params[:trade_status] == 'TRADE_SUCCESS'
      @order = current_user.orders.find params[:out_trade_no]
      @order.pay!(params[:trade_no])
    end
  end

  def alipay_notify
    notify_params = params.except(*request.path_parameters.keys)
    if Alipay::Sign.verify?(notify_params) && Alipay::Notify.verify?(notify_params)
      @order = EventOrder.find params[:out_trade_no]
      if ['TRADE_SUCCESS', 'TRADE_FINISHED'].include?(params[:trade_status])
        @order.pay!(params[:trade_no])
      elsif params[:trade_status] == 'TRADE_CLOSED'
        @order.cancel!
      end
      render text: 'success'
    else
      render text: 'fail'
    end
  end
end
