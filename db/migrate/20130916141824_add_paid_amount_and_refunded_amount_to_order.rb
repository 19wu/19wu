class AddPaidAmountAndRefundedAmountToOrder < ActiveRecord::Migration
  def up
    add_column :event_orders, :paid_amount_in_cents    , :integer, default: 0, null: false
    EventOrder.where(status: [:paid, :refund_pending]).each do |order|
      order.update_column :paid_amount_in_cents, order.price_in_cents
    end
  end

  def down
    remove_column :event_orders, :paid_amount_in_cents
  end
end
