class GroupTopicReply < ActiveRecord::Base
  extend HasHtmlPipeline
  belongs_to :topic, class_name: 'GroupTopic', counter_cache: 'replies_count', foreign_key: 'group_topic_id'
  belongs_to :user
  attr_accessible :body, :topic_id, :user_id
  validates :body, presence: true
  has_html_pipeline :body, :markdown
end
