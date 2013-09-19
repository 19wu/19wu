require 'spec_helper'

describe OrderRefundsController do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, event: event) }
  let(:trade_no) { '2013080841700373' }
  let(:refund) { order.refunds.submit amount: '10', reason: 'test' }
  let(:refund_batch) { RefundBatch.create }
  let(:result_details) { "2013080841700373^10^SUCCESS$jax_chuanhang@alipay.com^2088101003147483^0.01^SUCCESS" }

  before do
    order.pay(trade_no)
    refund.update_attribute :refund_batch_id, refund_batch.id
  end

  describe "POST alipay_notify" do
    let(:attrs) { { batch_no: refund_batch.batch_no, notify_id: '123', result_details: result_details, success_num: '1' } }
    before { Alipay::Notify.stub(:verify?).and_return(true) }
    it "should be success" do
      post :alipay_notify, attrs.merge(sign_type: 'md5', sign: Alipay::Sign.generate(attrs))
      expect(response).to be_success
      expect(refund_batch.reload.completed?).to be_true
      expect(refund.reload.refunded?).to be_true
      expect(order.reload.paid_amount).to eql 289.0
    end
  end
end
