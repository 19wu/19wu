require 'spec_helper'

describe Event::InvoicesController do

  describe "GET 'index'" do
    let(:user) { create(:user, :confirmed, :admin) }
    let!(:order) { create(:order_with_items, provide_invoice: true, paid: true) }
    before { login_user user }

    it "renders the invoice" do
      get 'index', event_id: order.event.id, format: :xlsx
      expect(assigns[:orders].first).to eql order
    end
  end

end
