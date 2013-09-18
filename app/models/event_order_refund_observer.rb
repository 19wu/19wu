class EventOrderRefundObserver< ActiveRecord::Observer
  def after_refund(refund, transition)
    refund.order.update_attribute :refunded_amount, refund.amount
  end

  def after_submit(refund, transition)
    OrderMailer.delay.notify_support_refund(refund)
  end
end
