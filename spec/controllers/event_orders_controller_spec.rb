require 'spec_helper'

describe EventOrdersController do

  describe "POST create" do
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, user: user) }
    let(:ticket) { create(:event_ticket, event: event, tickets_quantity: 400) }
    before { login_user user }
    context "with valid input" do
      it "should be success" do
        post :create, event_id: event.id, tickets: [{id: ticket.id, quantity: 2}]
        expect(response).to be_success
        expect(assigns[:order].items.size).to eql 1
        expect(JSON(response.body)['link']).to eql "https://mapi.alipay.com/gateway.do?service=create_direct_pay_by_user&_input_charset=utf-8&partner=2083528375739838&seller_email=admin%40example.com&payment_type=1&out_trade_no=1&subject=19wu+development+meeting+%E9%97%A8%E7%A5%A8&logistics_type=DIRECT&logistics_fee=0&logistics_payment=SELLER_PAY&price=598.0&quantity=1&discount=0&return_url=http%3A%2F%2Ftest.host%2Fevents%2F1%2Forders%2F1%2Fdone&notify_url=http%3A%2F%2Ftest.host%2Fevents%2F1%2Forders%2F1%2Fnotify&sign_type=MD5&sign=c733e600992902d6d3fdc1ffc02faeb7"
      end
    end
  end

end
