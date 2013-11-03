# -*- coding: utf-8 -*-
require "spec_helper"

describe OrderFulfillmentMailer do
  let(:user) { create(:user, :confirmed, :admin) }
  let(:order) { create(:order_with_items, require_invoice: true, paid: true) }
  let(:event) { order.event }
  let(:fulfillment) { create :event_order_fulfillment, order: order }

  describe "notify" do
    describe "user" do
      describe "fulfilled" do
        subject { OrderFulfillmentMailer.notify_user_fulfilled(fulfillment) }
        its(:subject) { should eql "#{order.event.title} 订单 #{order.number}，已经向您快递发票" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [order.user.email] }
        its('body.decoded') { should match "顺丰快递单号：#{fulfillment.tracking_number}" }
      end
    end

    describe "organizer" do
      describe "fulfilled" do
        subject { OrderFulfillmentMailer.notify_organizer_fulfilled(fulfillment) }
        its(:subject) { should eql "#{event.title} 订单 #{order.number}，已经向用户快递发票" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [event.user.email] }
        its('body.decoded') { should match "顺丰快递单号：#{fulfillment.tracking_number}" }
      end
    end
  end
end
