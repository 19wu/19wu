class CreateEventOrders < ActiveRecord::Migration
  def change
    create_table :event_orders do |t|
      t.integer :event_id, null: false
      t.integer :user_id, null: false
      t.integer :quantity, null: false
      t.float :price, null: false

      t.timestamps
    end
  end
end
