module UserOrdersHelper
  def order_status(order)
    t("views.my_orders.pay_status.#{order.status}") unless order.status.blank?
  end

  def pay_link(order)
    if order.can_pay?
      link_to t('views.my_orders.pay'), pay_user_order_path(order)
    end
  end

  def cancel_link(order)
    if order.can_cancel?
      link_to t('views.my_orders.cancel'), cancel_user_order_path(order),
              data: {confirm: t('confirmations.my_orders.cancel')}
    end
  end

  def request_refund_link(order)
    if order.can_request_refund?
      link_to t('views.my_orders.request_refund'), request_refund_user_order_path(order),
              data: {confirm: t('confirmations.my_orders.refund')}
    end
  end

  def operations(order)
    [pay_link(order), cancel_link(order), request_refund_link(order)].compact.join(' | ').html_safe
  end
end
