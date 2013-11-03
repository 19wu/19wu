# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_fulfillment do
    order
    tracking_number '112521197075'
  end
end
