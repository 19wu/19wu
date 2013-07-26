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

  def time
    if @datetime && (@datetime.hour != 0 || @datetime.min != 0 || @datetime.sec != 0)
      @datetime.strftime("%I:%M %p")
    end
  end

  def date=(date)
    if date.blank?
      @datetime = nil
    else
      @datetime = Time.zone.parse([date, self.time].compact.join(' '))
    end
  end

  def time=(time)
    return if @datetime == nil

    if time.blank?
      @datetime = @datetime.change(:hour => 0, :min => 0, :sec => 0)
    else
      date = @datetime.strftime('%Y-%m-%d')
      @datetime = Time.zone.parse([date, time].join(' '))
    end
  end

  def persisted?; false; end
end
