class EventOrderParticipant < ActiveRecord::Base
  belongs_to :event
  belongs_to :order
  belongs_to :user

  validates :checkin_code, uniqueness: { scope: :event_id }
end
