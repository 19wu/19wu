# -*- coding: utf-8 -*-
class EventOrdersController < ApplicationController
  include AlipayGeneratable
  include HasApiResponse
  before_filter :authenticate_user!, only: [:create, :alipay_done]

  def create
    event = Event.find params[:event_id]

    current_user.update_attributes! user_params
    @order = EventOrder.place_order current_user, event, order_params

    respond_to do |format|
      format.json
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
