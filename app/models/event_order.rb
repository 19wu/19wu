class EventOrder < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :items, class_name: 'EventOrderItem', foreign_key: "order_id"

  before_create do
    self.quantity = self.items.map(&:quantity).sum
    self.price = self.items.map(&:price).sum
    event.decrement! :tickets_quantity, self.quantity
  end
end
