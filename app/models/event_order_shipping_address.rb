class EventOrderShippingAddress < ActiveRecord::Base
  belongs_to :order
  validates :invoice_title, :province, :city, :district, :address, :name, :phone, presence: true

  def info
    "#{full_address} #{name} #{phone}"
  end

  def full_address
    "#{ChinaCity.get(province)}#{ChinaCity.get(city)}#{ChinaCity.get(district)} #{address}"
  end
end
