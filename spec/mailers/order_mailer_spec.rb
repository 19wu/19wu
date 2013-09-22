# -*- coding: utf-8 -*-
require "spec_helper"

describe OrderMailer do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, require_invoice: true, event: event) }
  let(:trade_no) { '2013080841700373' }
  let(:participant) { order.create_participant }
  let(:refund) { create :event_order_refund, :submited, order: order }

  describe "notify" do
    describe "user" do
      describe "order created" do
        subject { OrderMailer.notify_user_created(order) }
        its(:subject) { should eql '您在19屋的订单下单成功' }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [order.user.email] }
        its('body.decoded') { should match '收货人信息' }
        context 'free' do
          let(:order) { create(:order_with_items, tickets_price: 0, require_invoice: true, event: event) }
          its('body.decoded') { should_not match '如果您尚未付款' }
        end
      end
      describe "order paid" do
        subject { OrderMailer.notify_user_paid(order) }
        its(:subject) { should eql "订单 #{order.number} 完成支付" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [order.user.email] }
        its('body.decoded') { should match '我们已收到您支付的款项' }
        context 'from alipay' do
          before { order.pay(trade_no) }
          its('body.decoded') { should_not match '支付方式：银行汇款' }
        end
        context 'from bank transfer' do
          before { order.pay }
          its('body.decoded') { should match '支付方式：银行汇款' }
        end
      end
      describe "order checkin code" do
        subject { OrderMailer.notify_user_checkin_code(participant) }
        its(:subject) { should eql "订单 #{order.number} 活动签到码 #{participant.checkin_code}" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [order.user.email] }
        its('body.decoded') { should match "#{event.title} 签到码：#{participant.checkin_code}。" }
      end
      describe "order refunded" do
        before { order.pay(trade_no) }
        subject { OrderMailer.notify_user_refunded(refund) }
        its(:subject) { should eql "#{event.title} 订单 #{order.number}，已退款 #{refund.amount} 元" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [order.user.email] }
        its('body.decoded') { should match "已经向您退款 10.0 元" }
        its('body.decoded') { should match "退款原因：test" }
      end
    end

    describe "organizer" do
      describe "order created" do
        subject { OrderMailer.notify_organizer_created(order) }
        its(:subject) { should eql "#{event.title} 订单 #{order.number}，#{order.user.login} 下单" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [event.user.email] }
        its('body.decoded') { should match '刚刚新增了订单' }
      end
      describe "order paid" do
        subject { OrderMailer.notify_organizer_paid(order) }
        its(:subject) { should eql "#{event.title} 订单 #{order.number}，#{order.user.login} 完成支付" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [event.user.email] }
        its('body.decoded') { should match '成功支付款项' }
        context 'from alipay' do
          before { order.pay(trade_no) }
          its('body.decoded') { should_not match '支付方式：银行汇款' }
        end
        context 'from bank transfer' do
          before { order.pay }
          its('body.decoded') { should match '支付方式：银行汇款' }
        end
      end
      describe "order refunded" do
        before { order.pay(trade_no) }
        subject { OrderMailer.notify_organizer_refunded(refund) }
        its(:subject) { should eql "#{event.title} 订单 #{order.number}，已向 #{order.user.login} 退款 #{refund.amount} 元" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [event.user.email] }
        its('body.decoded') { should match "已经向 #{order.user.login} 退款 10.0 元" }
        its('body.decoded') { should match "退款原因：test" }
      end
    end

    describe "support" do
      describe "refund submit" do
        before { order.pay(trade_no) }
        subject { OrderMailer.notify_support_refund(refund) }
        its(:subject) { should eql "#{event.title} 订单 #{order.number}，主办方申请退款" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [Settings.email.from] }
        its('body.decoded') { should match '活动主办方刚刚申请退款' }
      end
    end
  end

end
