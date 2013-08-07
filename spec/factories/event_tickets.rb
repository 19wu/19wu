# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_ticket do
    name "公司票"
    price 299
    description "提供发票，发票项目为技术服务费，会后45天内统一发快递，票价包含顺丰发票快递费22元"
    event_id 1
  end
end
