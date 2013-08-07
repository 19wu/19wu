class EventTicket < ActiveRecord::Base
  belongs_to :event
  validates :name, :price, presence: true
  validates :name, :description, length: { maximum: 255 }
end
