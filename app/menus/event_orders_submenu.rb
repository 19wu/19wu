class EventOrdersSubmenu < TabsOnRails::Tabs::Builder
  def open_tabs(options = {})
    @context.tag("ul", {class: ['nav', 'nav-list']}.merge(options), open = true)
  end

  def tab_for(tab, name, path, current_path, item_options = {})
    item_options[:class] = (path == current_path ? 'active' : '')
    @context.content_tag(:li, item_options) do
      @context.link_to(name, path)
    end
  end
end
