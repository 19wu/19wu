class EventChange < ActiveRecord::Base
  attr_accessible :content
  belongs_to :event

  after_create do
    event.participated_users.each do |user|
      EventMailer.delay.change_email(self, user)
    end
  end
end
