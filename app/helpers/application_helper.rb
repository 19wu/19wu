module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def render_close_icon(dismiss = 'alert')
    link_to '&times;'.html_safe, '#', :class => 'close', 'data-dismiss' => dismiss
  end

  # return html class for flash_key
  def flash_class(flash_key)
    flash_key == :notice ? 'alert-success' : "alert-#{flash_key}"
  end

  def body_attributes
    class_attributes = [user_signed_in? ? 'signed_in' : 'signed_out']
    class_attributes << 'l-event' if controller_name == 'mockup' and action_name == 'event'
    {
      :class =>  class_attributes
    }
  end

  def render_user_bar
    if user_signed_in?
      render 'signed_in_user_bar'
    else
      render 'signed_out_user_bar'
    end
  end

  # Allow page to place flashes in specified place.
  # If the page did, do not render again.
  def render_flashes
    unless @_flahses_rendered
      @_flahses_rendered = true
      render 'flashes'
    end
  end

  def render_password_label_with_forget_link(object)
    link = link_to(t('devise.views.links.forget_pass'),
                   new_password_path(resource_name),
                   :tabindex => -1)

    html = object.class.human_attribute_name(:password) +
      ' (' + content_tag(:small, link) + ')'

    html.html_safe
  end

  def render_settings_tab(label, path, active_controller)
    if controller_name == active_controller
      content_tag :li, :class => 'active' do
        link_to label, '#settings-main'
      end
    else
      content_tag :li do
        link_to label, path
      end
    end
  end
end
