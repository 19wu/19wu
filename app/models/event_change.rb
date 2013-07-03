class EventChange < ActiveRecord::Base
  attr_accessible :content
  belongs_to :event
  validates :content, length: { maximum: 50 }

  after_create do
    event.participated_users.each do |user|
      EventMailer.delay.change_email(self, user)
    end
    phones = event.participated_users.with_phone.map(&:phone)
    ChinaSMS.delay.to phones, I18n.t('sms.event.change', content: content) unless phones.empty?
  end
end
