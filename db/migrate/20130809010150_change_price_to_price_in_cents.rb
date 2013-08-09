class ChangePriceToPriceInCents < ActiveRecord::Migration
  def up
    add_column :event_tickets    , :price_in_cents, :integer, null: false, default: 0
    add_column :event_orders     , :price_in_cents, :integer, null: false, default: 0
    add_column :event_order_items, :price_in_cents, :integer, null: false, default: 0
    EventTicket.all.each { |ticket| ticket.update_column :price_in_cents, (ticket.attributes['price'] * 100).to_i }
    EventOrder.all.each  { |order| order.update_column :price_in_cents, (order.attributes['price'] * 100).to_i }
    EventOrderItem.all.each  { |item| item.update_column :price_in_cents, (item.attributes['price'] * 100).to_i }
    remove_column :event_tickets    , :price
    remove_column :event_orders     , :price
    remove_column :event_order_items, :price
  end

  def down
    add_column :event_tickets    , :price, :float, null: false, default: 0
    add_column :event_orders     , :price, :float, null: false, default: 0
    add_column :event_order_items, :price, :float, null: false, default: 0
    EventTicket.all.each { |ticket| ticket.update_column :price, ticket.price_in_cents / 100.0 }
    EventOrder.all.each  { |order| order.update_column :price, order.price_in_cents / 100.0 }
    EventOrderItem.all.each  { |item| item.update_column :price, item.price_in_cents / 100.0 }
    remove_column :event_tickets    , :price_in_cents
    remove_column :event_orders     , :price_in_cents
    remove_column :event_order_items, :price_in_cents
  end
end
