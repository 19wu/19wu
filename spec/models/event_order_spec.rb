# -*- coding: utf-8 -*-
require 'spec_helper'

describe EventOrder do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:trade_no) { '2013080841700373' }
  let(:order) { create(:order_with_items, event: event) }
  subject { order }

  describe '#create' do
    describe 'validate' do
      subject { order.errors.messages }
      describe 'tickets' do
        before { order.valid? }
        let(:order) { EventOrder.build_order(user, event, {}) }
        its([:quantity]) { should_not be_empty }
      end
      describe 'shipping_address' do
        let(:ticket) { event.tickets.first }
        let(:order) { EventOrder.build_order(user, event, items_attributes: [{ticket_id: ticket.id, quantity: 1}]) }
        before do
          ticket.update_attribute :require_invoice, true
          order.valid?
        end
        its([:shipping_address]) { should_not be_nil }
      end
    end
    describe 'notification' do
      let(:mail) { double('mail') }
      before { mail.should_receive(:deliver) }
      describe 'user' do
        describe 'order created' do
          before { OrderMailer.should_receive(:notify_user_created).and_return(mail) }
          it { should_not be_nil }
        end
        describe 'order paid' do
          before do
            OrderMailer.should_receive(:notify_user_paid).and_return(mail)
            order.pay! trade_no
          end
          it { should_not be_nil }
        end
      end
      describe 'organizer' do
        describe 'order created' do
          before { OrderMailer.should_receive(:notify_organizer_created).and_return(mail) }
          it { should_not be_nil }
        end
        describe 'order paid' do
          before do
            OrderMailer.should_receive(:notify_organizer_paid).and_return(mail)
            order.pay! trade_no
          end
          it { should_not be_nil }
        end
      end
    end
    describe '#number' do
      before { Timecop.freeze('2013-08-25') }
      after { Timecop.return }
      its(:number) { should eql '201308250001' }
    end
    describe '#status' do
      its(:pending?) { should be_true }
      its(:paid?) { should be_false }
      its(:status_name) { should eql '未支付' }
    end
    describe '#shipping_address' do
      let(:order) { create(:order_with_items, shipping_address_attributes: attributes_for(:shipping_address), event: event) }
      its(:shipping_address) { should_not be_nil }
    end
    it 'should let user to follow event' do
      expect{order}.to change{event.group.followers}
    end
    context 'free' do
      let(:order) { create(:order_with_items, tickets_price: 0, event: event) }
      its(:pending?) { should be_false }
      its(:free?) { should be_true }
      its(:paid?) { should be_true }
      describe 'participant' do
        let(:order) { build(:order_with_items, tickets_price: 0, event: event) }
        it 'should be create' do
          order.should_receive(:create_participant)
          order.save
        end
      end
    end
    context 'business' do # 收费活动
      let(:order) { create(:order_with_items, event: event) }
      describe 'participant' do
        it 'should be create' do
          order.should_not_receive(:create_participant)
          order.save
        end
      end
    end
  end

  describe '#pay' do
    before { subject.pay(trade_no) }
    context 'paid' do
      its(:pending?) { should be_false }
      its(:paid?) { should be_true }
      its(:canceled?) { should be_false }
      its(:trade_no) { should eql trade_no }
      its(:paid_amount) { should eql subject.price }
    end
    context 'refund' do
      before { subject.request_refund! }
      its(:paid?) { should be_false }
      its(:refund_pending?) { should be_true }
    end

    its(:participant) { should_not be_nil }
  end

  describe '#pay_with_bank_transfer?' do
    before { subject.pay }
    its(:pay_with_bank_transfer?) { should be_true }
  end

  describe '#cancel' do
    context 'pending order' do
      before { order.cancel! }
      describe 'event' do
        subject { event }
        its(:tickets_quantity) { should eql 400 }
      end
    end
    context 'paid order' do
      before { order.pay!(trade_no) }
      context 'when event has not been finished' do
        before { order.cancel! }
        its(:canceled?) { should be_true }
      end
      context 'when event has been finished' do
        before do
          Timecop.travel(1.day.since(event.end_time))
          # order.cancel! # it will raise error
          order.cancel
        end
        after { Timecop.return }
        its(:canceled?) { should be_false }
      end
    end
  end

  describe "can not request refund when event start draws near" do
    before do
      event.update_attributes! start_time: 1.days.since, end_time: 2.days.since
      order.pay!(trade_no)
    end
    subject { order }
    its(:request_refund) { should be_false }
  end

  describe 'forbid participant when total quantity is 0' do
    let(:order) { build(:order_with_items, items_count: 600, event: event) }

    subject { order }
    its(:save) { should be_false }
  end

  describe 'event tickets quantity' do
    let(:order) { create(:order_with_items, items_count: 2, event: event) }
    subject { event }
    before { order }
    its(:tickets_quantity) { should eql 398 }
  end

  describe 'clean up expired orders' do
    before do
      order.update_attributes! created_at: 4.days.ago
      EventOrder.cleanup_expired
      order.reload
    end
    subject { order }
    its(:closed?) { should be_true }
  end
end
