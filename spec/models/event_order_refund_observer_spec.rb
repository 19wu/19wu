require 'spec_helper'

describe EventOrderRefundObserver do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, event: event) }
  let(:trade_no) { '2013080841700373' }
  let(:refund) { order.refunds.create amount: '10', reason: 'test' }

  before { order.pay(trade_no) }

  context 'submit' do
    let(:mail) { double('mail') }
    it 'should notify all followers' do
      mail.should_receive(:deliver)
      OrderMailer.should_receive(:notify_support_refund).and_return(mail)
      refund.submit!
    end
  end

  context 'refund' do
    before { refund.submit! }
    describe 'order' do
      before do
        order.update_attribute :refunded_amount, 15
        refund.reload.refund!
      end
      subject { order.reload }
      its(:refunded_amount) { should eql 25.0 }
    end
  end
end
