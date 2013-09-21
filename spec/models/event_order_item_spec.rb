require 'spec_helper'

describe EventOrderItem do
  let(:event) { create(:event) }
  let(:order) { create(:order_with_items, event: event, quantity: 2) }
  let(:order_item) { order.items.first }

  describe 'create' do
    subject { order_item }
    its(:unit_price) { should eql 299.0 }
  end
end
