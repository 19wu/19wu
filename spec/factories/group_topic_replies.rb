# encoding: utf-8
FactoryGirl.define do
  factory :group_topic_reply do
    body "非常赞成！"
    group_topic_id 1
    user_id 1
  end
end
