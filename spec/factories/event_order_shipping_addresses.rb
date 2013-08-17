# -*- coding: utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_order_shipping_address do
    order_id 1
    invoice_title "深圳市19屋电子商务有限公司"
    province "440000"
    city "440300"
    district "440305"
    address "科技园南区"
    name "saberma"
    phone "13928452888"
  end

  factory :shipping_address, parent: :event_order_shipping_address do
  end
end
