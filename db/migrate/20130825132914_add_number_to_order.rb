class AddNumberToOrder < ActiveRecord::Migration
  def change
    add_column :event_orders, :number, :string, limit: 16
  end
end
