class RemoveCanceledAtFromEventOrders < ActiveRecord::Migration
  def change
    remove_column :event_orders, :canceled_at
  end
end
