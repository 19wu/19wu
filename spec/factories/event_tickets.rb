# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_ticket do
    name "MyString"
    price 1.5
    description "MyString"
    event_id 1
  end
end
