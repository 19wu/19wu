class EventOrderRefundObserver< ActiveRecord::Observer
  def after_refund(refund, transition)
    refund.order.update_attribute :refunded_amount, refund.amount
  end
end
