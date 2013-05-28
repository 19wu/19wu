class Group < ActiveRecord::Base
  belongs_to :user
  has_many :events
  has_many :collaborators, :class_name => "GroupCollaborator"
  attr_accessible :slug
  acts_as_followable
end
