require 'spec_helper'

describe EventOrdersController do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:ticket) { create(:event_ticket, event: event, tickets_quantity: 400) }
  before { login_user user }

  describe "POST create" do
    it "should be success" do
      post :create, event_id: event.id, tickets: [{id: ticket.id, quantity: 2}]
      expect(response).to be_success
      expect(assigns[:order].items.size).to eql 1
      json = JSON(response.body)
      expect(json['status']).to eql 'pending'
      expect(json['link']).to eql "https://mapi.alipay.com/gateway.do?service=create_direct_pay_by_user&_input_charset=utf-8&partner=2083528375739838&seller_email=admin%40example.com&payment_type=1&out_trade_no=1&subject=19wu+development+meeting+%E9%97%A8%E7%A5%A8&logistics_type=DIRECT&logistics_fee=0&logistics_payment=SELLER_PAY&price=598.0&quantity=1&discount=0&return_url=http%3A%2F%2Ftest.host%2Fevents%2F1%2Forders%2F1%2Falipay_done&notify_url=http%3A%2F%2Ftest.host%2Fevents%2F1%2Forders%2F1%2Falipay_notify&sign_type=MD5&sign=c7c4f1a68c91317a0d98e36b721833de"
    end
    context 'free' do
      let(:ticket) { create(:event_ticket, :free, event: event, tickets_quantity: 400) }
      it "should not return pay link" do
        post :create, event_id: event.id, tickets: [{id: ticket.id, quantity: 2}]
        json = JSON(response.body)
        expect(json['link']).to be_nil
        expect(json['status']).to eql 'paid'
      end
    end
  end

  describe 'alipay' do
    let(:trade_no) { '2013080841700373' }
    let(:order) { create(:order_with_items, event: event) }
    let(:attrs) { { trade_no: trade_no, out_trade_no: order.id, trade_status: trade_status, total_fee: order.price } }
    describe "GET alipay_done" do
      context 'trade is success' do
        let(:trade_status) { 'TRADE_SUCCESS' }
        it "should be success" do
          get :alipay_done, attrs.merge(event_id: event.id, order_id: order.id, sign_type: 'md5', sign: Alipay::Sign.generate(attrs))
          expect(response).to be_success
          expect(order.reload.paid?).to be_true
        end
      end
    end

    describe "POST alipay_notify" do
      let(:attrs) { { trade_no: trade_no, out_trade_no: order.id, notify_id: '123', trade_status: trade_status, total_fee: order.price } }
      before { Alipay::Notify.stub(:verify?).and_return(true) }
      context 'trade is success' do
        let(:trade_status) { 'TRADE_SUCCESS' }
        it "should be success" do
          post :alipay_notify, attrs.merge(event_id: event.id, order_id: order.id, sign_type: 'md5', sign: Alipay::Sign.generate(attrs))
          expect(response).to be_success
          expect(order.reload.paid?).to be_true
        end
      end
    end
  end

end
