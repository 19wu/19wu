class EventOrderRefund < ActiveRecord::Base
  belongs_to :order, class_name: 'EventOrder'
  belongs_to :refund_batch
  priceable :amount

  validates :amount_in_cents, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  def self.refunding
    self.where(status: 'submited').last
  end

  def self.submit(params= {})
    self.create(params).tap(&:submit!)
  end

  state_machine :status, :initial => :pending do
    state :pending, :submited, :refunded

    event :submit do
      transition :pending => :submited
    end

    event :refund do
      transition :submited => :refunded
    end
  end
end
