module UserOrdersHelper
  def order_status(order)
    t("views.my_orders.pay_status.#{order.status}") unless order.status.blank?
  end

  def pay_link(order)
    link_to t('views.my_orders.pay'), pay_user_order_path(order) if order.pending?
  end

  def cancel_link(order)
    link_to t('views.my_orders.cancel'), cancel_user_order_path(order), data: { confirm: t('views.my_orders.confirm.cancel') } if order.pending?
  end

  def operations(order)
    [pay_link(order), cancel_link(order)].delete_if {|i| i.nil?}.join(' | ').html_safe
  end
end
