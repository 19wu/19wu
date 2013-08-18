class EventOrderShippingAddress < ActiveRecord::Base
  belongs_to :order
  validates :invoice_title, :province, :city, :district, :address, :name, :phone, presence: true

  def info
    "#{ChinaCity.get(province)}#{ChinaCity.get(city)}#{ChinaCity.get(district)} #{address} #{name} #{phone}"
  end
end
