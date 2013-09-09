module EventOrderHelper
  def stats_tickets_quantity(orders)
    orders.map(&:quantity).reduce(&:+) || 0
  end

  def stats_tickets_price(orders)
    orders.map(&:price).reduce(&:+) || 0
  end
end
