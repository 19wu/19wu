class EventSummary < ActiveRecord::Base
  extend HasHtmlPipeline

  attr_accessible :content, :event_id

  belongs_to :event

  has_html_pipeline :content, :markdown
  
  validates_presence_of :content
  validates :content, :length => { :minimum => 10 }
end