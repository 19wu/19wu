class GroupTopicReply < ActiveRecord::Base
  belongs_to :topic, class_name: 'GroupTopic'
  belongs_to :user
  attr_accessible :body, :topic_id, :user_id
  validates :body, presence: true
end
