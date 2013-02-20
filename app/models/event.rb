class Event < ActiveRecord::Base
  extend CompoundDatetime::HasCompoundDatetime
  extend HasHtmlPipeline
  belongs_to :user
  belongs_to :group
  has_many :participants, :class_name => "EventParticipant"
  has_many :participated_users, :source => :user, :through => :participants do
    def recent(count = nil)
      order('event_participants.created_at DESC').limit(count)
    end
  end

  has_compound_datetime :start_time
  has_compound_datetime :end_time
  has_html_pipeline :content, :markdown
  has_html_pipeline :location_guide, :markdown

  attr_accessor :slug
  attr_accessible :content, :location, :location_guide, :start_time, :end_time, :title, :slug
  attr_accessible :compound_start_time_attributes
  attr_accessible :compound_end_time_attributes

  validates :title, :location, presence: true
  validates :slug, presence: true
  validates :compound_start_time, presence: true

  validate :end_time_must_after_start_time
  validate :slug_must_uniq

  default_scope order('start_time DESC')

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

  def slug_must_uniq
    if User.exists?(:login => slug) or (group = Group.find_by_slug(slug) and group.user != user) or !FancyUrl.valid_for_short_url?(slug)
      errors.add(:slug, I18n.t('errors.messages.taken'))
    end
  end
end
