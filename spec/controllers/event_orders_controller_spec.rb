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
      expect(json['link']).to eql "https://mapi.alipay.com/gateway.do?service=create_direct_pay_by_user&_input_charset=utf-8&partner=2083528375739838&seller_email=admin%40example.com&payment_type=1&out_trade_no=1&subject=19wu+development+meeting+%E9%97%A8%E7%A5%A8&logistics_type=DIRECT&logistics_fee=0&logistics_payment=SELLER_PAY&price=598.0&quantity=1&discount=0&return_url=http%3A%2F%2Ftest.host%2Fuser_orders%2F1%2Falipay_done&notify_url=http%3A%2F%2Ftest.host%2Fuser_orders%2F1%2Falipay_notify&sign_type=MD5&sign=a4501f57c0b709c2a98e96525c4cdf07"
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
end
