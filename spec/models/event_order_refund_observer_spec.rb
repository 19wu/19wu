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
      subject { refund.order }
      context 'paid_amount is not zero' do
        before { refund.reload.refund! }
        its(:paid_amount) { should eql 289.0 }
      end
      context 'paid_amount is zero' do
        let(:refund) { create :event_order_refund, :submited, order: order, amount: order.price }
        it 'should call order cancel' do # instead of call order.cancel!
          refund.order.should_receive(:cancel)
          refund.refund!
        end
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
