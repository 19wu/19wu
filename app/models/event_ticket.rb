class EventTicket < ActiveRecord::Base
  belongs_to :event
  priceable :price
  validates :name, :price, presence: true
  validates :name, :description, length: { maximum: 255 }
  attr_writer :tickets_quantity
  delegate :tickets_quantity, to: :event

  before_save do
    event.update_column :tickets_quantity, @tickets_quantity if @tickets_quantity.present?
  end

  after_destroy do
    event.update_column :tickets_quantity, nil if event.tickets.count.zero?
  end
end
