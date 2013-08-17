class EventOrderParticipant < ActiveRecord::Base
  belongs_to :event
  belongs_to :order, class_name: 'EventOrder'

  validates :checkin_code, uniqueness: { scope: :event_id }

  before_create do
    self.event = self.order.event
    self.checkin_code = self.class.unique_code(self.event)
  end

  after_create do
    ChinaSMS.delay.to order.user.phone, I18n.t('sms.event.order.checkin_code', event_title: event.title, checkin_code: self.checkin_code, event_start_time: I18n.localize(event.start_time, format: :short))
  end

  class << self
    def unique_code(event)
      code = random_code
      while event.participants.exists?(checkin_code: code)
        code = random_code
      end
      code
    end

    def random_code
      Random.rand(100000..999999).to_s
    end
  end
end
