class EventSubmenu < TabsOnRails::Tabs::Builder
  def open_tabs(options = {})
    @context.tag("ul", {class: ['nav', 'nav-list']}.merge(options), open = true)
  end

  def tab_for(tab, name, options, item_options = {})
    item_options[:class] = (current_tab?(tab) ? 'active' : '')
    @context.content_tag(:li, item_options) do
      @context.link_to(name, options)
    end
  end
end
