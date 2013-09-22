class AddUnitPriceToEventOrderItem < ActiveRecord::Migration
  def change
    add_column :event_order_items, :unit_price_in_cents, :integer, default: 0, null: false
    EventOrderItem.all.each do |event_order_item|
      event_order_item.update_column :unit_price_in_cents, (event_order_item.price_in_cents / event_order_item.quantity)
    end
  end
end
