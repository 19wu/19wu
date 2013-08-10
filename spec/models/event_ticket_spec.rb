require 'spec_helper'

describe EventTicket do
  let(:event) { create :event }
  describe '#tickets_quantity' do
    let(:ticket) { build(:event_ticket, event: Event.find(event.id), tickets_quantity: 400) }
    describe '#create' do
      subject { ticket.tap(&:save) }
      its(:tickets_quantity) { should eql 400 }
    end

    context 'exists' do
      before { ticket.save }
      subject { event.reload }
      describe '#update' do
        before { ticket.update_attribute :tickets_quantity, 500 }
        its(:tickets_quantity) { should eql 500 }
      end

      describe '#destroy' do
        context 'with other ticket' do
          before do
            create(:event_ticket, event: Event.find(event.id), name: 'other', tickets_quantity: 500)
            ticket.destroy
          end
          its(:tickets_quantity) { should eql 500 }
        end
        context 'without other ticket' do
          before { event.tickets.destroy_all }
          its(:tickets_quantity) { should eql nil }
        end
      end
    end
  end
end
