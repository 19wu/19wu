require 'spec_helper'

describe EventOrderRefundObserver do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, event: event) }
  let(:trade_no) { '2013080841700373' }

  before { order.pay(trade_no) }

  context 'submit' do
    let(:refund) { order.refunds.submit attributes_for(:event_order_refund) }
    let(:mail) { double('mail') }
    it 'should notify support' do
      mail.should_receive(:deliver)
      OrderMailer.should_receive(:notify_support_refund).and_return(mail)
      refund
    end
  end

  context 'refund' do
    let(:refund) { create :event_order_refund, :submited, order: order }
    describe 'order' do
      before { refund.reload.refund! }
      subject { order.reload }
      its(:paid_amount) { should eql 289.0 }
      context 'paid_amount is zero' do
        let(:refund) { create :event_order_refund, :submited, order: order, amount: order.price }
        its(:canceled?) { should be_true }
      end
    end
    describe 'mail to' do
      let(:mail) { double('mail') }
      describe 'organizer' do
        it 'should be done' do
          mail.should_receive(:deliver)
          OrderMailer.should_receive(:notify_organizer_refunded).and_return(mail)
          refund.refund!
        end
      end
    end
  end
end
