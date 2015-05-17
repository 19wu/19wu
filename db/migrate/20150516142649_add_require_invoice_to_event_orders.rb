class AddRequireInvoiceToEventOrders < ActiveRecord::Migration
  def change
    add_column :event_orders, :require_invoice, :boolean, default: false

    EventOrder.find_each(batch_size: 100) do |order|
      order.update_column :require_invoice, order.provide_invoice
    end
  end
end
