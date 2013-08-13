class EventOrderShippingAddress < ActiveRecord::Base
  belongs_to :order
  validates :invoice_title, :province, :city, :district, :address, :name, :phone, presence: true
end
