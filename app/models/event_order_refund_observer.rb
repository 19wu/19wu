class EventOrderRefundObserver< ActiveRecord::Observer
  def after_refund(refund, transition)
    order = refund.order
    order.decrement! :paid_amount_in_cents, refund.amount_in_cents
    order.cancel if order.paid_amount_in_cents <= 0
    OrderMailer.delay.notify_organizer_refunded(refund)
    OrderMailer.delay.notify_user_refunded(refund)
  end

  def after_submit(refund, transition)
    OrderMailer.delay.notify_support_refund(refund)
  end
end
