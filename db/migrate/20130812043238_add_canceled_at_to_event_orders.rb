class AddCanceledAtToEventOrders < ActiveRecord::Migration
  def change
    add_column :event_orders, :canceled_at, :timestamp
  end
end
