class SendCheckinCodeSmsForFreeEvent < ActiveRecord::Migration
  def up
    change_column :event_orders, :trade_no, :string, limit: 32
  end

  def down
    change_column :event_orders, :trade_no, :string, limit: 16
  end
end
