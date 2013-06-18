class EventChange < ActiveRecord::Base
  attr_accessible :content
  belongs_to :event
end
