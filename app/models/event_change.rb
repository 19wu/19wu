class EventChange < ActiveRecord::Base
  belongs_to :event
  validates :content, length: { maximum: 100 }

  after_create do
    event.ordered_users.each do |user|
      EventMailer.delay.change_email(self, user)
    end
    phones = event.ordered_users.with_phone.map(&:phone).sort
    ChinaSMS.delay.to phones, I18n.t('sms.event.change', content: content) unless phones.empty?
  end
end
