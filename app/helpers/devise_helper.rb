module DeviseHelper
  def render_password_label_with_forget_link(object)
    link = link_to(t('links.forget_pass'),
                   new_password_path(resource_name),
                   :tabindex => -1)

    html = object.class.human_attribute_name(:password) +
      ' (' + content_tag(:small, link) + ')'

    html.html_safe
  end
end
