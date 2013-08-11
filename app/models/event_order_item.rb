class EventOrderItem < ActiveRecord::Base
  belongs_to :order, class_name: 'EventOrder'
  belongs_to :ticket, class_name: 'EventTicket'
  priceable :price
end
