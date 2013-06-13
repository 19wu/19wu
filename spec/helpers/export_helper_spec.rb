# encoding: utf-8
require 'spec_helper'

describe ExportHelper do

  describe '#markdown_format_content' do
    it 'the event has not summary' do
      event = create(:event, :markdown)
      markdown_format_content(event).should == markdown_content_has_not_summary_example(event)
    end

    it 'the event has summary' do
      event = create(:event, :markdown)
      create(:event_summary, event: event)

      markdown_format_content(event).should == markdown_content_has_summary_example(event)
    end
  end

  def markdown_content_has_not_summary_example(event)
    %Q{#### #{t('activerecord.attributes.event.title')}

#{event.title}


#### #{t('views.export.event_time')}

#{time_merge(event)}


#### #{t('activerecord.attributes.event.location')}

#{event.location}


#### #{t('activerecord.attributes.event.content')}

#{event.content}}
  end

  def markdown_content_has_summary_example(event)
    %Q{#### #{t('activerecord.attributes.event.title')}

#{event.title}


#### #{t('views.export.event_time')}

#{time_merge(event)}


#### #{t('activerecord.attributes.event.location')}

#{event.location}


#### #{t('activerecord.attributes.event.content')}

#{event.content}


#### #{t('views.summary')}

#{event.event_summary.content}}
  end
end
