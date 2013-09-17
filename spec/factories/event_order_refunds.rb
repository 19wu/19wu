# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_refund do
    order_id 1
    amount_in_cents 1
    reason "MyString"
  end
end
