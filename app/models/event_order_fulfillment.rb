class EventOrderFulfillment < ActiveRecord::Base
  belongs_to :order
  validates :tracking_number, presence: true
  validates :tracking_number, length: { is: 12 }, allow_blank: true
end
