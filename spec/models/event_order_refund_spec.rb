require 'spec_helper'

describe EventOrderRefund do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, event: event) }
  let(:trade_no) { '2013080841700373' }
  let(:refund) { order.refunds.create amount: '10', reason: 'test' }

  subject { refund }
  before { order.pay(trade_no) }

  describe 'validate' do
    let(:refund) { order.refunds.build }
    before { refund.valid? }
    subject { refund.errors.messages }
    describe 'amount_in_cents' do
      context 'blank' do
        its([:amount_in_cents]) { should eql [I18n.t('errors.messages.blank')] }
      end
      context 'great than 0' do
        let(:refund) { order.refunds.build amount: '0' }
        its([:amount_in_cents]) { should eql [I18n.t('errors.messages.greater_than', count: 0)] }
      end
      context 'less than order paid amount' do
        let(:refund) { order.refunds.build amount: '300' }
        its([:amount_in_cents]) { should eql [I18n.t('errors.messages.event_order_refund.amount_in_cents.less_than', paid_amount: 299.0)] }
      end
    end
  end

  describe 'create' do
    its(:pending?) { should be_true }
    its(:amount) { should eql 10.0 }
    its(:reason) { should eql 'test' }

    context 'submited' do
      before { refund.submit! }
      its(:submited?) { should be_true }
      describe 'order refunds' do
        subject { order.refunds }
        it(:refunding?) { should be_true }
      end

      context 'refunded' do
        before { refund.reload.refund! }
        its(:refunded?) { should be_true }
        describe 'order' do
          subject { refund.order }
          its(:paid_amount) { should eql 289.0 }
        end
      end
    end
  end
end
