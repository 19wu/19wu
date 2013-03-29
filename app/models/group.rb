class Group < ActiveRecord::Base
  belongs_to :user
  has_many :events
  attr_accessible :slug
  acts_as_followable
end
