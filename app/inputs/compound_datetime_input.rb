class CompoundDatetimeInput < SimpleForm::Inputs::Base
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
    template.content_tag(:div, :class => 'time input-append bootstrap-timepicker') do
      builder.text_field(:time, :class => 'timepicker') + timepicker_add_on
    end
  end

  def datepicker_add_on
    template.content_tag(:span, :class => 'add-on') do
      template.content_tag(:i, '', :class => 'icon-calendar datepicker-trigger')
    end
  end

  def timepicker_add_on
    template.content_tag(:span, :class => 'add-on') do
      template.content_tag(:i, '', :class => 'icon-time timepicker-trigger')
    end
  end
end
