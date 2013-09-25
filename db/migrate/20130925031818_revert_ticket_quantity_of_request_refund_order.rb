class RevertTicketQuantityOfRequestRefundOrder < ActiveRecord::Migration
  def up
    # full-refunded order will be cancel, and then the quantity will be restock.
    EventOrder.where(status: 'refund_pending').each do |order|
      order.event.decrement! :tickets_quantity, order.quantity if order.event.tickets_quantity
    end
  end

  def down
    EventOrder.where(status: 'refund_pending').each do |order|
      order.event.increment! :tickets_quantity, order.quantity if order.event.tickets_quantity
    end
  end
end
