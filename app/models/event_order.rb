class EventOrder < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :items, class_name: 'EventOrderItem', foreign_key: "order_id"
  priceable :price

  before_create do
    self.quantity = self.items.map(&:quantity).sum
    self.price_in_cents = self.items.map(&:price_in_cents).sum
    self.status = :pending
    self.status = :paid if self.price_in_cents.zero?
    event.decrement! :tickets_quantity, self.quantity if event.tickets_quantity
  end

  def pending?
    self.status.to_sym == :pending
  end
  def paid?
    self.status.to_sym == :paid
  end

  def pay(trade_no)
    self.update_attributes status: 'paid', trade_no: trade_no if pending?
  end
end
