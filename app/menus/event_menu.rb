class EventMenu < TabsOnRails::Tabs::Builder
  def open_tabs(options = {})
    @context.tag("ul", {class: 'nav'}.merge(options), open = true)
  end

  def tab_for(tab, name, options, item_options = {})
    item_options[:class] = (current_tab?(tab) ? 'active' : '')
    @context.content_tag(:li, item_options) do
      @context.link_to(name, options)
    end + @context.tag("li", class: 'divider-vertical')
  end
end
