class AddNumberToOrder < ActiveRecord::Migration
  def up
    add_column :event_orders, :number, :string, limit: 16
    EventOrder.all.each do |order|
      order.update_column :number, Sequence.get
    end
    change_column :event_orders, :number, :string, limit: 16, null: false
  end

  def down
    remove_column :event_orders, :number
  end
end
