class CreateEventOrders < ActiveRecord::Migration
  def change
    create_table :event_orders do |t|
      t.integer :event_id, null: false
      t.integer :user_id, null: false
      t.integer :quantity, null: false
      t.float :price, null: false
      t.string :status, limit: 16
      t.string :trade_no, limit: 16

      t.timestamps
    end
    add_index :event_orders, :event_id
    add_index :event_orders, :user_id
  end
end
