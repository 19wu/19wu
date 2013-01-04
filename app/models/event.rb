class Event < ActiveRecord::Base
  extend CompoundDatetime::HasCompoundDatetime

  has_compound_datetime :start_time
  has_compound_datetime :end_time

  attr_accessible :content, :location, :start_time, :end_time, :title
  attr_accessible :compound_start_time_attributes
  attr_accessible :compound_end_time_attributes

  validates :title, :location, presence: true
  validates :compound_start_time, presence: true
end
