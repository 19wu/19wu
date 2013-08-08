class CreateEventOrderItems < ActiveRecord::Migration
  def change
    create_table :event_order_items do |t|
      t.integer :order_id , null: false
      t.integer :ticket_id, null: false
      t.integer :quantity , null: false
      t.float :price      , null: false

      t.timestamps
    end
  end
end
