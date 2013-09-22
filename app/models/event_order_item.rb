class EventOrderItem < ActiveRecord::Base
  belongs_to :order, class_name: 'EventOrder'
  belongs_to :ticket, class_name: 'EventTicket'
  priceable :price, :unit_price

  validates :ticket, presence: true, on: :create
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_in_cents, :unit_price_in_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  delegate :require_invoice, to: :ticket

  before_validation do
    if new_record?
      self.price_in_cents = calculate_price_in_cents
      self.unit_price_in_cents = ticket.price_in_cents
    end
  end

  # Ensure ticket_id exists and use price in database.
  def self.filter_attributes(event, items_attributes)
    items_attributes = Array.wrap(items_attributes)

    # build tickets lookup table
    tickets_ids = items_attributes.collect { |attrs| attrs[:ticket_id] }
    tickets_table = {}
    event.tickets.where(id: tickets_ids).each do |ticket|
      tickets_table[ticket.id] = ticket
    end

    items_attributes.collect { |attrs|
      ticket = tickets_table[attrs[:ticket_id]]
      if ticket
        {
          ticket: ticket,
          quantity: attrs[:quantity].to_i,
          price_in_cents: attrs[:quantity].to_i * ticket.price_in_cents
        }
      end
    }.compact
  end

  def price_in_cents
    if new_record?
      # always calculate on the fly for new record
      calculate_price_in_cents
    else
      self[:price_in_cents]
    end
  end

  def calculate_price_in_cents
    ticket.price_in_cents * quantity
  end

  def name
    self.ticket ? self.ticket.name : 'deleted'
  end
end
