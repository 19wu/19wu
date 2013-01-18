class Event < ActiveRecord::Base
  extend CompoundDatetime::HasCompoundDatetime
  extend HasHtmlPipeline
  belongs_to :user
  has_many :participants, :class_name => "EventParticipant"

  has_compound_datetime :start_time
  has_compound_datetime :end_time
  has_html_pipeline :content, :markdown
  has_html_pipeline :location_guide, :markdown

  attr_accessible :content, :location, :location_guide, :start_time, :end_time, :title
  attr_accessible :compound_start_time_attributes
  attr_accessible :compound_end_time_attributes

  validates :title, :location, presence: true
  validates :compound_start_time, presence: true

  validate :end_time_must_after_start_time

  default_scope order('start_time ASC')

  scope :unfinished, where(["end_time > ? ", Time.now])

  def has?(user)
    return user && participants.exists?(user_id: user.id)
  end

  private
  def end_time_must_after_start_time
    if end_time.present? && start_time.present? && end_time < start_time
      message = I18n.t('errors.messages.greater_than_or_equal_to', :count => Event.human_attribute_name(:start_time))
      errors.add(:compound_end_time, message)
      errors.add(:end_time, message)
    end
  end
end
