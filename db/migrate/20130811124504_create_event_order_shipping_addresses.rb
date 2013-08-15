class CreateEventOrderShippingAddresses < ActiveRecord::Migration
  def change
    create_table :event_order_shipping_addresses do |t|
      t.integer :order_id, null: false
      t.string :invoice_title
      t.string :province , limit: 64
      t.string :city     , limit: 64
      t.string :district , limit: 64
      t.string :address
      t.string :name     , limit: 64
      t.string :phone    , limit: 64

      t.timestamps
    end
  end
end
