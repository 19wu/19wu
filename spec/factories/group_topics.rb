# encoding: utf-8
FactoryGirl.define do
  factory :group_topic do
    title "收集大家感兴趣的主题"
    body "如题"
    user

    trait :with_group do
      group
    end
  end
end
