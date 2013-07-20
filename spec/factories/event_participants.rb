# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_participant do
    user_id 1
    event_id 1
    trait :random_user do
      user
    end
  end
end
