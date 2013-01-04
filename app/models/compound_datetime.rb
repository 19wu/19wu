class CompoundDatetime
  extend Forwardable

  attr_accessor :date
  attr_accessor :time

  ATTRIBUTES = %w(date hour min sec meridian)

  def initialize(datetime = nil)
    @datetime = datetime || Time.zone.now
  end

  def assign_attributes(attributes)
    attributes.slice(*ATTRIBUTES).each do |k, v|
      send "#{k}=", v
    end
  end

  # am/pm
  def meridian
    @datetime.strftime('%P')
  end

  # hours 1-12
  def hour
    if @datetime.hour == 0
      12
    elsif @datetime.hour > 12
      @datetime.hour - 12
    else
      @datetime.hour
    end
  end

  def_delegators :@datetime, :min, :sec
  def_delegator :@datetime, :to_date, :date

  def date=(date)
    return unless date.present?

    unless date.is_a?(Time) || date.is_a?(Date)
      date = Time.zone.parse(date)
    end

    @datetime = @datetime.change(:year => date.year, :month => date.month, :day => date.day)
  end

  def hour=(hour)
    assign_time(hour.to_i, meridian, min, sec)
  end

  def min=(min)
    assign_time(hour, meridian, min, sec)
  end

  def sec=(sec)
    assign_time(hour, meridian, min, sec)
  end

  def meridian=(meridian)
    meridian = 'am' if meridian != 'pm'
    assign_time(hour, meridian, min, sec)
  end

  def persisted?; false; end

  private
  def assign_time(hour12, meridian, min, sec)
    hour24 = hour12.to_i
    if meridian == 'am'
      hour24 = 0 if hour24 == 12
    else
      hour24 += 12 if hour24 != 12
    end

    @datetime = @datetime.change(:hour => hour24, :min => min.to_i, :sec => sec.to_i)
  end
end
