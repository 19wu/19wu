class ApplicationController < ActionController::Base
  protect_from_forgery

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
end
