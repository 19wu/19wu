require 'spec_helper'

describe OrderRefundsController do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, event: event) }
  let(:trade_no) { '2013080841700373' }

  before { order.pay(trade_no) }

  describe "POST submit" do
    before { login_user user }
    let(:refund) { build :event_order_refund, order: order }
    it "should be success" do
      post :submit, event_id: event.id, id: order.id, refund: { amount: refund.amount, reason: refund.reason }, format: 'json'
      expect(response).to be_success
    end
  end

  describe "POST alipay_notify" do
    let(:refund) { create :event_order_refund, :submited, order: order }
    let(:refund_batch) { RefundBatch.create }
    let(:result_details) { "2013080841700373^10^SUCCESS$jax_chuanhang@alipay.com^2088101003147483^0.01^SUCCESS" }
    let(:attrs) { { batch_no: refund_batch.batch_no, notify_id: '123', result_details: result_details, success_num: '1' } }
    before do
      Alipay::Notify.stub(:verify?).and_return(true)
      refund.update_attribute :refund_batch_id, refund_batch.id
    end
    it "should be success" do
      post :alipay_notify, attrs.merge(sign_type: 'md5', sign: Alipay::Sign.generate(attrs))
      expect(response).to be_success
      expect(refund_batch.reload.completed?).to be_true
      expect(refund.reload.refunded?).to be_true
      expect(order.reload.paid_amount).to eql 289.0
    end
  end
end
