module EventTicketHelper
  def init_tickets(event)
    tickets = event.tickets.select([:id, :name, :price, :require_invoice, :description]).to_a
    tickets.map! do |ticket|
      item = ticket.as_json
      item[:quantity] = 0
      item
    end
    options = { tickets: tickets }
    options.to_ng_init
  end
end
