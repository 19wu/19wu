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
    {
      :class => user_signed_in? ? 'signed_in' : 'signed_out'
    }
  end

  def render_user_bar
    if user_signed_in?
      render 'signed_in_user_bar'
    else
      render 'signed_out_user_bar'
    end
  end
end
