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
    describe '#status' do
      its(:pending?) { should be_true }
      its(:paid?) { should be_false }
    end
    describe '#shipping_address' do
      let(:order) { create(:order_with_items, shipping_address_attributes: attributes_for(:shipping_address), event: event) }
      its(:shipping_address) { should_not be_nil }
    end
    context 'free' do
      let(:order) { create(:order_with_items, price: 0, event: event) }
      its(:pending?) { should be_false }
      its(:paid?) { should be_true }
    end
  end

  describe '#pay' do
    before { subject.pay!(trade_no) }
    context 'pending' do
      its(:pending?) { should be_false }
      its(:paid?) { should be_true }
      its(:canceled?) { should be_false }
      its(:trade_no) { should eql trade_no }
    end
    context 'refunding' do # only pending order can be pay
      before { subject.update_attribute :status, 'refunding' }
      its(:paid?) { should be_false }
      its(:refunding?) { should be_true }
    end
  end

  describe 'cancel order' do
    before { order.cancel! }
    subject { event }
    its(:tickets_quantity) { should eql 400 }
  end

  describe "can not refund when event start draws near" do
    before do
      order.pay!(trade_no)
    end
    subject { order }
    its(:refund!) { should be_false }
  end

  describe "refund order back its ticket's quantity immediately" do
    before do
      event.update! start_time: 8.days.since, end_time: 9.days.since
      order.pay!(trade_no)
      order.refund!
    end
    subject { event }
    its(:tickets_quantity) { should eql 400 }
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
end
