# -*- coding: utf-8 -*-
class EventOrdersController < ApplicationController
  include AlipayGeneratable
  include HasApiResponse
  before_filter :authenticate_user!, only: [:create]
  before_filter :authorize_event!, only: [:index]

  set_tab :order, only: [:index]

  set_tab :all, :sidebar, only: [:index]
  set_tab :pending, :sidebar, only: [:index]
  set_tab :paid, :sidebar, only: [:index]
  set_tab :canceled, :sidebar, only: [:index]
  set_tab :refund_pending, :sidebar, only: [:index]
  set_tab :refunded, :sidebar, only: [:index]

  def create
    event = Event.find params[:event_id]

    current_user.update_attributes! user_params
    @order = EventOrder.place_order current_user, event, order_params

    respond_to do |format|
      format.json
    end
  end

  def index
    @orders = @event.orders.includes(items: :ticket)
    if params[:status] && EventOrder.state_machines[:status].states.map(&:name).include?(params[:status].to_sym)
      @orders = @orders.where status: params[:status]
    end
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:phone, profile_attributes: [:name])
  end

  def order_params
    params.fetch(:order, {}).permit({
      items_attributes: [:ticket_id, :quantity],
      shipping_address_attributes: [:invoice_title, :province, :city, :district, :address, :name, :phone]
    })
  end
end
