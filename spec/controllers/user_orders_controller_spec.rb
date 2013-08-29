require 'spec_helper'

describe UserOrdersController do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  before { login_user user }

  describe 'alipay' do
    let(:trade_no) { '2013080841700373' }
    let(:order) { create(:order_with_items, event: event, user: user) }
    let(:attrs) { { trade_no: trade_no, out_trade_no: order.number, trade_status: trade_status, total_fee: order.price } }
    describe "GET alipay_done" do
      let(:trade_status) { 'TRADE_SUCCESS' }
      context 'trade is success' do
        it "should be success" do
          get :alipay_done, attrs.merge(id: order.id, sign_type: 'md5', sign: Alipay::Sign.generate(attrs))
          expect(response).to be_success
          expect(order.reload.paid?).to be_true
        end
      end
      context 'order has paid by alipay notify page request' do
        before { order.pay!(trade_no) }
        it "should be success" do
          expect do
            get :alipay_done, attrs.merge(id: order.id, sign_type: 'md5', sign: Alipay::Sign.generate(attrs))
          end.not_to raise_error #StateMachine::InvalidTransition
          expect(response).to be_success
          expect(order.reload.paid?).to be_true
        end
      end
    end

    describe "POST alipay_notify" do
      let(:attrs) { { trade_no: trade_no, out_trade_no: order.number, notify_id: '123', trade_status: trade_status, total_fee: order.price } }
      let(:trade_status) { 'TRADE_SUCCESS' }
      before { Alipay::Notify.stub(:verify?).and_return(true) }
      context 'trade is success' do
        it "should be success" do
          post :alipay_notify, attrs.merge(id: order.id, sign_type: 'md5', sign: Alipay::Sign.generate(attrs))
          expect(response).to be_success
          expect(order.reload.paid?).to be_true
        end
      end
      context 'order has paid by alipay done page request' do
        before { order.pay!(trade_no) }
        it "should be success" do
          expect do
            post :alipay_notify, attrs.merge(id: order.id, sign_type: 'md5', sign: Alipay::Sign.generate(attrs))
          end.not_to raise_error #StateMachine::InvalidTransition
          expect(response).to be_success
          expect(order.reload.paid?).to be_true
        end
      end
    end
  end

  describe 'GET index' do
    let(:another_event) { create(:event, slug: 'another') }
    let!(:order) { create(:order_with_items, event: event, user: user) }
    let!(:another_order) { create(:order_with_items, event: another_event, user: user) }
    describe 'event_id filter' do
      it 'returns orders for the specified event' do
        get 'index', event_id: event.id
        expect(assigns[:orders]).to eq([order])
      end
    end
  end
end
