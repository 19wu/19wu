class EventOrderRefund < ActiveRecord::Base
  belongs_to :order, class_name: 'EventOrder'
  priceable :amount

  validates :amount_in_cents, presence: true, numericality: { greater_than: 0 }
end
