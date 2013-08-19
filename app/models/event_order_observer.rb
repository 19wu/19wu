# -*- coding: utf-8 -*-
class EventOrderObserver < ActiveRecord::Observer
  def after_pay(order, transition)
    order.create_participant
    OrderMailer.delay.notify_user_paid(order)
    OrderMailer.delay.notify_organizer_paid(order)
  end

  def after_cancel(order, transition)
    order.event.increment! :tickets_quantity, order.quantity if order.event.tickets_quantity
  end

  def after_request_refund(order, transition)
    order.event.increment! :tickets_quantity, order.quantity if order.event.tickets_quantity
  end
end
