class AddStatusToEventTickets < ActiveRecord::Migration
  def change
    add_column :event_tickets, :status, :string

    EventTicket.all.update_all(status: :opened)
  end
end
