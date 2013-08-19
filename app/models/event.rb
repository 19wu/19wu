class Event < ActiveRecord::Base
  extend CompoundDatetime::HasCompoundDatetime
  extend HasHtmlPipeline
  belongs_to :user
  belongs_to :group
  has_one :event_summary
  has_many :participants, :class_name => "EventOrderParticipant"
  has_many :updates,      :class_name => "EventChange"
  has_many :tickets,      :class_name => "EventTicket"
  has_many :orders,       :class_name => "EventOrder"
  has_many :ordered_users, :source => :user, :through => :orders do # TODO: uniq
    def recent(count = nil)
      order('event_orders.created_at DESC').limit(count)
    end
    def with_phone
      where("users.phone is not null and users.phone != ''")
    end
  end

  has_compound_datetime :start_time
  has_compound_datetime :end_time
  has_html_pipeline :content, :markdown
  has_html_pipeline :location_guide, :markdown

  attr_accessor :slug

  validates :title, :location, presence: true
  validates :slug, presence: true
  validates :compound_start_time, presence: true

  validate :end_time_must_after_start_time
  validate :slug_must_uniq

  scope :latest, -> { order('start_time DESC') }

  scope :upcoming, lambda { |today = Time.zone.now|
    tomorrow = today.since(1.day)
    where(:start_time => tomorrow.beginning_of_day..tomorrow.end_of_day)
  }

  def sibling_events
    group.events.latest.select { |e| e != self }
  end

  def checkin_code
    created_at.strftime('%H%M%S').chars.to_a.values_at(1, 3, 5).join # 12:11:10 => 210
  end

  def self.remind_participants
    Event.upcoming.find_each do |e|
      e.ordered_users.each do |user|
        UserMailer.delay.reminder_email user, e
      end
    end
  end

  def started?
    start_time.past?
  end

  def finished?
    !end_time.nil? && Time.now.utc > end_time.utc
  end

  def show_summary?
    !!(event_summary || !finished? && group.last_event_with_summary)
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
    if User.exists?(:login => slug) || !user.owns?(slug) || !FancyUrl.valid_for_short_url?(slug)
      errors.add(:slug, I18n.t('errors.messages.taken'))
    end
  end
end
