class EventOrderFulfillment < ActiveRecord::Base
  belongs_to :order
  validates :tracking_number, presence: true
end
