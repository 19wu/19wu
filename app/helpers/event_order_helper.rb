module EventOrderHelper
  def stats_tickets_quantity(orders)
    orders.map(&:quantity).reduce(&:+) || 0
  end

  def stats_tickets_price(orders)
    (orders.map(&:price_in_cents).reduce(&:+) || 0) / 100.0
  end

  def init_event_orders(orders = @orders)
    orders = Jbuilder.new do |json|
      json.array! @orders do |order|
        json.(order, :id, :number, :price)
        json.submit_refund_form false
        json.user order.user, :login, :email
        json.items order.items, :price, :quantity, :name
      end
    end.attributes! # http://git.io/DQj7LQ
    options = { orders: orders }
    options.to_ng_init
  end
end
