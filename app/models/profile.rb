class Profile < ActiveRecord::Base
  extend HasHtmlPipeline

  belongs_to :user
  # attr_accessible :bio, :name, :website
  validates :name, length: { maximum: 20 }

  has_html_pipeline :bio, :profile_markdown
end
