# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_topic_reply do
    body "MyText"
    topic_id 1
    user_id 1
  end
end
