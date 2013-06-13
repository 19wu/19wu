require 'event_helper'

module ExportHelper
  include EventHelper

  def markdown_format_content(event)
    markdown = []
    %w(title time location content).each do |method_name|
      markdown << send("#{method_name}_markdown", event)
    end
    markdown << summary_markdown(event) if event.show_summary?
    markdown.join("\n"*3)
  end

  def clippy(text, bgcolor='#FFFFFF')
    html = <<-EOF
      <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
              width="110"
              height="14"
              id="clippy" >
      <param name="movie" value="/flash/clippy.swf"/>
      <param name="allowScriptAccess" value="always" />
      <param name="quality" value="high" />
      <param name="scale" value="noscale" />
      <param name="FlashVars" value='text=#{text}'>
      <param name="bgcolor" value="#{bgcolor}">
      <embed src="/flash/clippy.swf"
             width="110"
             height="14"
             name="clippy"
             quality="high"
             allowScriptAccess="always"
             type="application/x-shockwave-flash"
             pluginspage="http://www.macromedia.com/go/getflashplayer"
             FlashVars='text=#{text}'
             bgcolor="#{bgcolor}"
      />
      </object>
    EOF
    html.html_safe
  end

  private
  %w(title location content).each do |field|
    class_eval %Q{
      def #{field}_markdown(event)
        [build_markdown_item_title(t('activerecord.attributes.event.#{field}')), event.#{field}].join("\n"*2)
      end
    }
  end

  def time_markdown(event)
    [build_markdown_item_title(t('views.export.event_time')), time_merge(event)].join("\n"*2)
  end

  def summary_markdown(event)
    [build_markdown_item_title(build_summary_title(event)), build_markdown_summary_content(event)].join("\n"*2)
  end

  def build_markdown_item_title(item_title)
    "#### #{item_title}"
  end

  def build_markdown_summary_content(event)
    if event.event_summary
      return event.event_summary.content
    elsif !event.finished? && event.group.last_event_with_summary
      return event.group.last_event_with_summary.event_summary.content
    end
  end
end
