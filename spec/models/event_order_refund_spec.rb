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
    its([:amount_in_cents]) { should_not be_empty }
  end

  describe 'create' do
    its(:pending?) { should be_true }
    its(:amount) { should eql 10.0 }
    its(:reason) { should eql 'test' }
    describe 'ordedr' do
      subject { refund.order }
      its(:refunded_amount) { should eql 0.0 }
    end

    context 'submited' do
      before { refund.submit! }
      its(:submited?) { should be_true }
      describe 'ordedr' do
        subject { refund.order }
        its(:refunded_amount) { should eql 0.0 }
      end

      context 'confirmed' do
        before { refund.confirm! }
        its(:confirmed?) { should be_true }
        describe 'ordedr' do
          subject { refund.order }
          its(:refunded_amount) { should eql 0.0 }
        end

        context 'refunded' do
          before { refund.reload.refund! }
          its(:refunded?) { should be_true }
          describe 'ordedr' do
            subject { refund.order }
            its(:refunded_amount) { should eql 10.0 }
          end
        end
      end
    end
  end
end
