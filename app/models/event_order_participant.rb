class EventOrderParticipant < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :order, class_name: 'EventOrder'

  validates :checkin_code, uniqueness: { scope: :event_id }
  after_create :send_sms

  before_create do
    self.event = self.order.event
    self.user  = self.order.user
    self.checkin_code = self.class.unique_code(self.event)
  end

  def joined?
    self.checkin_at
  end

  def send_sms
    ChinaSMS.delay.to user.phone, I18n.t('sms.event.order.checkin_code', event_title: event.title, checkin_code: self.checkin_code, event_start_time: I18n.localize(event.start_time, format: :short))
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
