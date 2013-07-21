class Group < ActiveRecord::Base
  belongs_to :user
  has_many :events
  has_many :collaborators, class_name: "GroupCollaborator"
  has_many :topics, class_name: "GroupTopic"
  acts_as_followable

  def collaborator?(user)
    self.collaborators.exists?(user_id: user.id)
  end

  def last_event_with_summary
    events.latest.each do |event|
      return event unless event.event_summary.nil?
    end
    nil
  end
end
