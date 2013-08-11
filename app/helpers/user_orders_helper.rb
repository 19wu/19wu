module UserOrdersHelper
  def order_status(order)
    t("views.my_orders.pay_status.#{order.status}") unless order.status.blank?
  end
end
