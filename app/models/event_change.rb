class EventChange < ActiveRecord::Base
  attr_accessible :content
  belongs_to :event

  after_create do
    emails = event.participated_users.map(&:email_with_login)
    EventMailer.delay.change_email(self, emails) unless emails.empty?
  end
end
