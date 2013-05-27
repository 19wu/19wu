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

  scope :latest, order('start_time DESC')

  scope :upcoming, lambda { |today = Time.zone.now|
    tomorrow = today.since(1.day)
    where(:start_time => tomorrow.beginning_of_day..tomorrow.end_of_day)
  }

  def has?(user)
    return user && participants.exists?(user_id: user.id)
  end

  def sibling_events
    group.events.latest.select { |e| e != self }
  end

  def self.remind_participants
    Event.upcoming.find_each do |e|
      e.participated_users.each do |participant|
        UserMailer.delay.reminder_email participant, e
      end
    end
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
    if User.exists?(:login => slug) || (group = Group.find_by_slug(slug) and group.user != user) || !FancyUrl.valid_for_short_url?(slug)
      errors.add(:slug, I18n.t('errors.messages.taken'))
    end
  end
end
