module UserOrdersHelper
  def order_status(order)
    t("views.my_orders.pay_status.#{order.status}") unless order.status.blank?
  end

  def pay_link(order)
    link_to t('views.my_orders.pay'), pay_user_order_path(order) if order.pending?
  end
end
