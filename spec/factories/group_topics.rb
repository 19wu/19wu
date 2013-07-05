# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_topic do
    title "MyString"
    body "MyText"
    user_id 1
  end
end
