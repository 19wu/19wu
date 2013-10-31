# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_fulfillment do
    order_id 1
    tracking_number "MyString"
  end
end
