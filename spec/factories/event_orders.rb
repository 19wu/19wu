# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order do
    event_id 1
    user_id 1
    price 1.5

    factory :order_with_items do
      ignore do
        items_count 1
        price 299
      end
      before(:create) do |order, evaluator|
        FactoryGirl.create_list(:ticket, evaluator.items_count, price: evaluator.price, event: order.event).each do |ticket|
          order.items.build ticket: ticket, quantity: 1, price: ticket.price
        end
      end
    end
  end

  factory :order, parent: :event_order do
  end
end
