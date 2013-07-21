class Profile < ActiveRecord::Base
  extend HasHtmlPipeline

  belongs_to :user
  validates :name, length: { maximum: 20 }

  has_html_pipeline :bio, :profile_markdown
end
