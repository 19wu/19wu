module Admin::OrderFulfillmentHelper
  def init_event_order_fulfillments(orders = @orders)
    orders = Jbuilder.new do |json|
      json.array! orders do |order|
        json.(order, :id, :number, :paid_amount)
        json.user order.user, :login, :email
        json.address order.shipping_address, :invoice_title, :info
        json.fulfillment order.fulfillment, :tracking_number if order.fulfillment
        items = order.items.select(&:require_invoice)
        json.items items do |item|
          json.(item, :price, :unit_price, :quantity, :name, :require_invoice)
        end
      end
    end.attributes! # http://git.io/DQj7LQ
    options = { orders: orders }
    options.to_ng_init
  end
end
