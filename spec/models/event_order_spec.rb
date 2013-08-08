require 'spec_helper'

describe EventOrder do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:ticket) { create(:event_ticket, event: event, tickets_quantity: 400) }
  let(:order) do
    o = event.orders.build user: user, event_id: event.id
    o.items.build ticket_id: ticket.id, quantity: 1, price: ticket.price
    o.save
    o
  end
  describe '#status' do
    let(:trade_no) { '123' }
    subject { order }
    its(:pending?) { should be_true }
    its(:paid?) { should be_false }
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
  end
end
