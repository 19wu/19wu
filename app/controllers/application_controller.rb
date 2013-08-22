class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location # http://git.io/-lVTIA
  before_filter :system_notification
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def user_path(user_or_login)
    if user_or_login.is_a?(User)
      login = user_or_login.login.to_s
    else
      login = user_or_login.to_s
    end

    path = '/' + login
    info = Rails.application.routes.recognize_path(path)

    return path if info[:controller] == 'users'

    url_for(:controller => 'users',
            :action => 'show',
            :id => login,
            :only_path => true)
  end
  helper_method :user_path

  def store_location
    # store last url as long as it isn't a /users path
    if request.get? && request.fullpath !~ /\/(users|api)/
      session[:previous_url] = request.fullpath
    end
  end

  def redirect_back_or(url, *args)
    url = session.delete(:previous_url) || url
    redirect_to url, *args
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  # TODO: return json for angular
  # cancan exception handler
  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      render "application/403", status: 403
    else
      redirect_to new_user_session_path, alert: I18n.t("unauthorized.default")
    end
  end

  protected
  def authorize_event!
    @event = Event.find(params[:event_id])
    authorize! :update, @event
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:login, :email, :phone, :password, :password_confirmation,:remember_me)
    end
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:login, :password, :password_confirmation, :invitation_token)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:login, :email, :phone, :password, :password_confirmation, :current_password)
    end
  end

  private
  def system_notification
    message = I18n.t('flash.user_phones.blank', here: view_context.link_to(I18n.t('flash.user_phones.here'), edit_user_phone_path)).html_safe
    flash.now[:alert] = message if current_user && current_user.phone.blank?
  end
end
