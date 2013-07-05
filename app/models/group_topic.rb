class GroupTopic < ActiveRecord::Base
  attr_accessible :body, :title
  belongs_to :group
  belongs_to :user
  validates :title, :body, presence: true
end
