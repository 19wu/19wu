# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_refund do
    amount '10'
    reason "test"

    trait :submited do
      status 'submited'
    end
  end
end
