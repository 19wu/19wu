require 'spec_helper'

describe EventTicket do
  let(:event) { create :event }
  describe '#tickets_quantity' do
    subject { create(:event_ticket, event: Event.find(event.id), tickets_quantity: 400) }
    its(:tickets_quantity) { should eql 400 }
  end
end
