require 'spec_helper'

describe Admin::OrderFulfillmentsController do
  let(:user) { create(:user, :confirmed, :admin) }
  let!(:order) { create(:order_with_items, require_invoice: true, paid: true) }
  before { login_user user }

  describe "GET index" do
    it "should be success" do
      get :index
      expect(assigns[:orders].first).to eql order
    end
  end

end
