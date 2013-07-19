class EventParticipant < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates :user_id, uniqueness: { scope: :event_id }

  after_create do
    user.follow event.group
  end
end
