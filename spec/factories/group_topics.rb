# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_topic do
    title "收集大家感兴趣的主题"
    body "如题"
    user
  end
end
