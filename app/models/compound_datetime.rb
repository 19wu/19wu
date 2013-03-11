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

  ATTRIBUTES = %w(date time)

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

  def time
    @datetime ? @datetime.strftime("%I:%M %p") : nil
  end

  def time=(time)
    return nil if time.blank?
    real_time = DateTime.parse(time)
    @datetime ||= Time.zone.now
    @datetime = @datetime.change(:hour => real_time.hour, :min => real_time.minute, :sec => real_time.second)
  end

  def persisted?; false; end
end
