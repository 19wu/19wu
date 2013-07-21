class GroupTopic < ActiveRecord::Base
  extend HasHtmlPipeline
  belongs_to :group
  belongs_to :user
  has_many :replies, class_name: "GroupTopicReply"
  validates :title, :body, presence: true
  has_html_pipeline :body, :markdown
end
