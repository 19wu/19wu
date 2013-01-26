class CompoundDatetimeInput < SimpleForm::Inputs::Base
  MERIDIAN_COLLECTION = lambda { [[I18n.t('time.am'), 'am'], [I18n.t('time.pm'), 'pm']] }
  HOUR_COLLECTION = (1..12).to_a.collect { |h| ['%02d' % h, h] }
  MIN_COLLECTION = (0..59).collect { |m| ['%02d' % m, m] }

  def initialize(*args)
    super

    @compound_wrapper_html = @options[:compound_wrapper_html] || {}
    @compound_wrapper_html[:class] = ['compound-controls',
                                      @compound_wrapper_html[:class]].compact
  end

  def input
    datetime = @builder.object.send(attribute_name) || CompoundDatetime.new

    @builder.fields_for(attribute_name, datetime) do |f|
      template.content_tag(:div, @compound_wrapper_html) do
        datepicker(f) + timepicker(f)
      end
    end
  end

  private
  def datepicker(builder)
    template.content_tag(:div, :class => 'date input-append') do
      builder.text_field(:date, :class => 'datepicker') + datepicker_add_on
    end
  end

  def timepicker(builder)
    template.content_tag(:div, :class => 'time') do
      builder.select(:hour, HOUR_COLLECTION, {:include_blank => true}, :class => 'time-hour') +
        template.content_tag(:span, ':', :class => 'time-separator muted') +
        builder.select(:min, MIN_COLLECTION, {:include_blank => true}, :class => 'time-min') +
        template.content_tag(:span, ' ', :class => 'time-separator muted') +
        builder.select(:meridian, MERIDIAN_COLLECTION.call, {:include_blank => true}, :class => 'time-meridian')
    end
  end

  def datepicker_add_on
    template.content_tag(:span, :class => 'add-on') do
      template.content_tag(:i, '', :class => 'icon-calendar datepicker-trigger')
    end
  end
end
