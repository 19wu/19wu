class EventSummary < ActiveRecord::Base
  attr_accessible :content, :event_id
  belongs_to :event

  validates_presence_of :content
  validates :content, :length => { :minimum => 10 }
end