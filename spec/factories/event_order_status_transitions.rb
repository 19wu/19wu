# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_status_transition do
    event_order nil
    event "MyString"
    from "MyString"
    to "MyString"
    created_at "2013-08-19 01:58:26"
  end
end
