# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_participant do
    order_id 1
    event_id 1
    checkin_code "1234"

    trait :checkin do
      checkin_at "2013-08-17 10:50:41"
    end
  end
end
