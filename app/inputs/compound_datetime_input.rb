class CompoundDatetimeInput < SimpleForm::Inputs::Base
  MERIDIAN_COLLECTION = lambda { [[I18n.t('time.am'), 'am'], [I18n.t('time.pm'), 'pm']] }
  HOUR_COLLECTION = (1..12).to_a.collect { |h| ['%02d' % h, h] }
  MIN_COLLECTION = (0..59).collect { |m| ['%02d' % m, m] }

  def input
    datetime = @builder.object.send(attribute_name) || CompoundDatetime.new
    @builder.fields_for(attribute_name, datetime) do |f|
      template.content_tag(:div, :class => 'compound-datetime row-fluid') do
        result = ''
        result += template.content_tag(:span, :class => 'input-append date span5') do
          f.text_field(:date, :class => 'span10 datepicker') +
            template.content_tag(:span, :class => 'add-on') do
            template.content_tag(:i, '', :class => 'icon-calendar datepicker-trigger')
          end
        end
        result += template.content_tag(:span, :class => 'time span6') do
          f.select(:hour, HOUR_COLLECTION, {:include_blank => true}, :class => 'time-hour') +
            template.content_tag(:span, ' : ', :class => 'muted') +
            f.select(:min, MIN_COLLECTION, {:include_blank => true}, :class => 'time-min') +
            f.select(:meridian, MERIDIAN_COLLECTION.call, {:include_blank => true}, :class => 'time-meridian')
        end

        result.html_safe
      end
    end
  end
end
