# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order do
    event
    user
    price 1.5

    factory :order_with_items do
      ignore do
        items_count 1
        quantity 1
        tickets_price 299
        require_invoice false
      end
      before(:create) do |order, evaluator|
        FactoryGirl.create_list(:ticket, evaluator.items_count, price: evaluator.tickets_price, require_invoice: evaluator.require_invoice, event: order.event).each do |ticket|
          order.items.build ticket: ticket, quantity: evaluator.quantity, price: ticket.price
        end
        if order.require_invoice
          order.shipping_address_attributes = attributes_for(:shipping_address)
        end
      end
    end
  end

  factory :order, parent: :event_order do
  end
end
