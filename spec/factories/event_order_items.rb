# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_item do
    order_id 1
    ticket
    quantity 1
    price 1.5
  end
end
