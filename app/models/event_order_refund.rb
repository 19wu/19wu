class EventOrderRefund < ActiveRecord::Base
  belongs_to :order, class_name: 'EventOrder'
  belongs_to :refund_batch
  priceable :amount

  validates :amount_in_cents, presence: true
  validates :amount_in_cents, numericality: { greater_than: 0 }, allow_blank: true
  validates :status, presence: true
  validate :amount_in_cents_cannot_be_great_than_order_paid_amount

  def self.refunding
    self.where(status: 'submited').last
  end

  def self.submit(params= {})
    self.create!(params).tap(&:submit!)
  end

  def amount_in_cents_cannot_be_great_than_order_paid_amount
    if self.amount_in_cents.present? && self.amount_in_cents > self.order.paid_amount_in_cents
      errors.add(:amount_in_cents, I18n.t('errors.messages.event_order_refund.amount_in_cents.less_than', paid_amount: self.order.paid_amount))
    end
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
