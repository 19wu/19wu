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
        order = assigns[:order]
        order.items.size.should eql 1
      end
    end
  end

end
