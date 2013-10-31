require 'spec_helper'

describe EventOrderFulfillment do
  let(:order) { create(:order_with_items, require_invoice: true, paid: true) }

  describe 'mail to' do
    let(:mail) { double('mail') }
    describe 'user' do
      it 'should be done' do
        mail.should_receive(:deliver)
        OrderFulfillmentMailer.should_receive(:notify_user_fulfilled).and_return(mail)
        order.create_fulfillment attributes_for(:event_order_fulfillment)
      end
    end
    describe 'organizer' do
      it 'should be done' do
        mail.should_receive(:deliver)
        OrderFulfillmentMailer.should_receive(:notify_organizer_fulfilled).and_return(mail)
        order.create_fulfillment attributes_for(:event_order_fulfillment)
      end
    end
  end
end
