require 'spec_helper'

describe AdminOrdersController do
  before { login_user user }

  describe "GET 'index'" do
    context 'user' do
      let(:user) { create(:user) }
      it "returns http failure" do
        get 'index'
        response.should_not be_success
      end
    end
    context 'admin' do
      let(:user) { create(:user, :admin) }
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end
  end

  describe "PATCH 'pay'" do
    let(:order) { create(:order_with_items) }
    context 'user' do
      let(:user) { create(:user) }
      it "returns http failure" do
        patch 'pay', id: order.id
        response.should_not be_success
      end
    end
    context 'admin' do
      let(:user) { create(:user, :admin) }
      it "returns http success" do
        patch 'pay', id: order.id
        response.should redirect_to(admin_orders_path(number: order.number))
      end
    end
  end

end
