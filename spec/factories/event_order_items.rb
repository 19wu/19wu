# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_item do
    order
    ticket
    quantity 1
  end
end
