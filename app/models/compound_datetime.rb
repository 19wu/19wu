class CompoundDatetime
  module HasCompoundDatetime
    def has_compound_datetime(field)
      define_method "compound_#{field}" do
        datetime = send(field)
        CompoundDatetime.new(datetime) if datetime
      end

      define_method "compound_#{field}_attributes=" do |attributes|
        compound_datetime = CompoundDatetime.new(send(field))
        compound_datetime.assign_attributes(attributes)
        send("#{field}=", compound_datetime.datetime)
      end
    end
  end

  ATTRIBUTES = %w(date hour min sec meridian)

  attr_reader :datetime

  def initialize(datetime = nil)
    @datetime = datetime
  end

  def assign_attributes(attributes)
    attributes.slice(*ATTRIBUTES).each do |k, v|
      send "#{k}=", v
    end

    self
  end

  # am/pm
  def meridian
    @datetime.try(:strftime, '%P') || @meridian
  end

  # hours 1-12
  def hour
    return nil unless @datetime.present?
    if @datetime.hour == 0
      12
    elsif @datetime.hour > 12
      @datetime.hour - 12
    else
      @datetime.hour
    end
  end

  def min
    @datetime.try(:min) || @min
  end

  def sec
    @datetime.try(:sec) || @sec
  end

  def date
    @datetime.try(:to_date)
  end

  def date=(date)
    return unless date.present?

    unless date.is_a?(Time) || date.is_a?(Date)
      date = Time.zone.parse(date).to_date
    end

    if @datetime
      @datetime = @datetime.change(:year => date.year, :month => date.month, :day => date.day)
    else
      @datetime = date.to_time
    end
  end

  def hour=(hour)
    assign_time(hour, meridian, min, sec)
  end

  def min=(min)
    @min = min
    assign_time(hour, meridian, min, sec)
  end

  def sec=(sec)
    @sec = sec
    assign_time(hour, meridian, min, sec)
  end

  def meridian=(meridian)
    @meridian = meridian
    @meridian = 'am' if @meridian != 'pm'
    assign_time(hour, @meridian, min, sec)
  end

  def persisted?; false; end

  private
  def assign_time(hour12, meridian, min, sec)
    return unless hour12.present?

    hour24 = hour12.to_i
    if meridian == 'am'
      hour24 = 0 if hour24 == 12
    else
      hour24 += 12 if hour24 != 12
    end

    @datetime ||= Time.zone.now
    @datetime = @datetime.change(:hour => hour24, :min => min.to_i, :sec => sec.to_i)
  end
end
