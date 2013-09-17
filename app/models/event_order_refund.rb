class EventOrderRefund < ActiveRecord::Base
  belongs_to :order, class_name: 'EventOrder'
  priceable :amount

  validates :amount_in_cents, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  def self.refunding
    self.where(status: [:submited, :confirmed]).last
  end

  def self.submit(params= {})
    self.create(params).tap(&:submit!)
  end

  state_machine :status, :initial => :pending do
    state :pending, :submited, :confirmed, :refunded

    event :submit do
      transition :pending => :submited
    end

    event :confirm do
      transition :submited => :confirmed
    end

    event :refund do
      transition :confirmed => :refunded
    end
  end
end
