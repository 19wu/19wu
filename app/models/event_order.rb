class EventOrder < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :event_order_status_transitions
  has_many :items, class_name: 'EventOrderItem', foreign_key: "order_id"
  has_one :participant     , class_name: 'EventOrderParticipant'    , foreign_key: "order_id"
  has_one :shipping_address, class_name: 'EventOrderShippingAddress', foreign_key: "order_id"
  priceable :price

  accepts_nested_attributes_for :items, :shipping_address

  validates :event_id, :user_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :quantity_cannot_be_greater_than_event_quantity, :invoice_should_has_address, on: :create

  before_validation do
    self.quantity = calculate_quantity
    self.price_in_cents = calculate_price_in_cents
  end

  before_create do
    self.status = free? ? 'paid' : 'pending'
    event.decrement! :tickets_quantity, self.quantity if event.tickets_quantity
  end

  after_create do
    OrderMailer.delay.notify_user_created(self)
    OrderMailer.delay.notify_organizer_created(self)
  end

  def free?
    self.price_in_cents.zero?
  end

  state_machine :status, :initial => :pending do
    store_audit_trail

    state :pending
    state :paid, :request_refund, :complete_refund do
      validates :trade_no, :presence => true
    end

    event :pay do
      transition :pending => :paid, :if => ->(order) { !order.event.finished? }
    end

    event :cancel do
      transition :pending => :canceled, :if => ->(order) { !order.event.finished? }
    end

    event :request_refund do
      transition :paid => :request_refund, :if => ->(order) { order.event.start_time - Time.now > 7.days }
    end

    event :complete_refund do
      transition :request_refund => :complete_refund
    end
  end

  # override state_machine generated method to accept trade_no
  def pay(trade_no)
    self.trade_no = trade_no
    super
  end

  def require_invoice
    items.map(&:require_invoice).any?
  end

  class<< self
    def build_order(user, event, params)
      items_attributes = EventOrderItem.filter_attributes(
          event,
          params[:items_attributes]
      )
      order_params = {
          user: user,
          status: :pending,
          items_attributes: items_attributes
      }
      order_params[:shipping_address_attributes] = params[:shipping_address_attributes] if params[:shipping_address_attributes]
      event.orders.build order_params
    end

    # TODO: validate, event and its inventory, #457, #467
    def place_order(user, event, params)
      build_order(user, event, params).tap do |order|
        order.save!
      end
    end
  end

  private

  def quantity_cannot_be_greater_than_event_quantity
    return unless event.tickets_quantity
    order_quantity = self.quantity || 0
    if event.tickets_quantity == 0 || order_quantity > event.tickets_quantity
      errors.add(:quantity, I18n.t('errors.messages.quantity_overflow'))
    end
  end

  def invoice_should_has_address
    if self.require_invoice && shipping_address.nil?
      errors.add(:shipping_address, I18n.t('errors.messages.event_order.miss_shipping_address'))
    end
  end

  def calculate_quantity
    items.map(&:quantity).sum
  end

  def calculate_price_in_cents
    items.map(&:price_in_cents).sum
  end
end
