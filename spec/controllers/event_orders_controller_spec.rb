require 'spec_helper'

describe EventOrdersController do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:ticket) { create(:event_ticket, event: event, tickets_quantity: 400) }
  let(:order_params) {
    { items_attributes: [{ticket_id: ticket.id, quantity: 2}] }
  }
  let(:user_params) {
    { phone: '13928452888', profile_attributes: { name: 'saberma' } }
  }
  before { login_user user }

  describe "POST create" do
    render_views

    before { Timecop.freeze('2013-08-25') }
    after { Timecop.return }
    it "should be success" do
      post :create, format: :json, event_id: event.id, order: order_params
      expect(response).to be_success
      expect(assigns[:order].items.size).to eql 1
      json = JSON(response.body)
      expect(json['status']).to eql 'pending'
      expect(json['link']).to eql "https://mapi.alipay.com/gateway.do?service=create_direct_pay_by_user&_input_charset=utf-8&partner=2083528375739838&seller_email=admin%40example.com&payment_type=1&out_trade_no=201308250001&subject=19wu+development+meeting+%E9%97%A8%E7%A5%A8&logistics_type=DIRECT&logistics_fee=0&logistics_payment=SELLER_PAY&price=598.0&quantity=1&discount=0&return_url=http%3A%2F%2Ftest.host%2Fuser_orders%2F1%2Falipay_done&notify_url=http%3A%2F%2Ftest.host%2Fuser_orders%2F1%2Falipay_notify&sign_type=MD5&sign=af33852fe33bd8cb4a95be9e99d12128"
    end

    context 'free' do
      let(:ticket) { create(:event_ticket, :free, event: event, tickets_quantity: 400) }
      it "should not return pay link" do
        post :create, format: :json, event_id: event.id, order: order_params
        json = JSON(response.body)
        expect(json['link']).to be_nil
        expect(json['status']).to eql 'paid'
      end
    end

    context 'require invoice' do
      let(:order_params) {
        {
          items_attributes: [{ticket_id: ticket.id, quantity: 2}],
          shipping_address_attributes: attributes_for(:shipping_address)
        }
      }
      before { ticket.update_attribute :require_invoice, true }
      it 'should be success' do
        post :create, format: :json, event_id: event.id, order: order_params
        expect(response).to be_success
        expect(assigns[:order].shipping_address).not_to be_nil
      end
    end

    describe "with user information" do
      before { post :create, event_id: event.id, order: order_params, user: user_params }
      context 'profile is not a new record' do
        let(:user) { create(:user, :confirmed, :with_profile) }
        it "should be update" do
          expect(user.reload.phone).to eql '13928452888'
          expect(user.profile.name).to eql 'saberma'
        end
      end
      context 'profile is a new record' do
        it "should be save" do
          expect(user.reload.phone).to eql '13928452888'
          expect(user.profile.new_record?).to be_false
          expect(user.profile.reload.name).to eql 'saberma'
        end
      end
    end
  end
end
