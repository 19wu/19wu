require 'spec_helper'

describe ParticipantsController do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:trade_no) { '2013080841700373' }
  let!(:order) { create(:order_with_items, event: event) }
  before { login_user user }

  describe "GET export" do
    before { order.pay! trade_no }
    it "should be success" do
      get :export, format: :xlsx, event_id: event.id
      expect(assigns[:orders].first).to eql order
      expect(response).to be_success
    end
  end
end
