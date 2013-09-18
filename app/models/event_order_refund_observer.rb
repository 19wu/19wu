class EventOrderRefundObserver< ActiveRecord::Observer
  def after_refund(refund, transition)
    order = refund.order
    order.update_attribute :refunded_amount_in_cents, (order.refunded_amount_in_cents + refund.amount_in_cents)
  end

  def after_submit(refund, transition)
    OrderMailer.delay.notify_support_refund(refund)
  end
end
