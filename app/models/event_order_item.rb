class EventOrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :ticket
  priceable :price
end
