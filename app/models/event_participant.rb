class EventParticipant < ActiveRecord::Base
  # attr_accessible :event_id, :user_id

  belongs_to :event
  belongs_to :user

  validates :user_id, uniqueness: { scope: :event_id }

  after_create do
    user.follow event.group
  end
end
