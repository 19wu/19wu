# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_refund do
    amount '1'
    reason "test"
  end
end
