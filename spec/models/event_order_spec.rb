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
      let(:order) { build(:order, event: event) }
      describe 'tickets' do
        before { order.valid? }
        its([:quantity]) { should_not be_empty }
      end
    end
    describe '#status' do
      its(:pending?) { should be_true }
      its(:paid?) { should be_false }
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
    context 'refund' do # only pending order can be pay
      before { subject.update_attribute :status, 'refund' }
      its(:paid?) { should be_false }
    end
  end

  describe 'cancel order' do
    before { order.cancel! }
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
