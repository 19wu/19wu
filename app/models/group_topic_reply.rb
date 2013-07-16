class GroupTopicReply < ActiveRecord::Base
  extend HasHtmlPipeline
  belongs_to :topic, class_name: 'GroupTopic', counter_cache: 'replies_count'
  belongs_to :user
  attr_accessible :body, :topic_id, :user_id
  validates :body, presence: true
  has_html_pipeline :body, :markdown

  before_save :update_counters

  private
  def update_counters
    GroupTopic.increment_counter(:replies_count, GroupTopic.find(self.group_topic_id))
    if self.group_topic_id_was.present?
      GroupTopic.decrement_counter(:replies_count, GroupTopic.find(self.group_topic_id_was))
    end
  end
end
