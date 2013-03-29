class EventParticipant < ActiveRecord::Base
  attr_accessible :event_id, :user_id

  belongs_to :event
  belongs_to :user

  after_create do
    user.follow event.group
  end
end
