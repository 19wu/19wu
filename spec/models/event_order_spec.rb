require 'spec_helper'

describe EventOrder do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:trade_no) { '2013080841700373' }
  let(:order) { create(:order_with_items, tickets_quantity: 400, event: event) }
  subject { order }

  describe '#status' do
    its(:pending?) { should be_true }
    its(:paid?) { should be_false }
  end

  describe '#pay' do
    before { subject.pay(trade_no) }
    context 'pending' do
      its(:pending?) { should be_false }
      its(:paid?) { should be_true }
      its(:trade_no) { should eql trade_no }
    end
    context 'refund' do # only pending order can be pay
      before { subject.update_attribute :status, 'refund' }
      its(:paid?) { should be_false }
    end
  end

  describe 'event tickets quantity' do
    let(:order) { create(:order_with_items, items_count: 2, event: event) }
    subject { event }
    before { order }
    its(:tickets_quantity) { should eql 398 }
  end
end
