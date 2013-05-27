class Group < ActiveRecord::Base
  belongs_to :user
  has_many :events
  attr_accessible :slug
  acts_as_followable

  def last_event_with_summary
    events.latest.each do |event|
      return event unless event.event_summary.nil?
    end

    nil
  end
end
