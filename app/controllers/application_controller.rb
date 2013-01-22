class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :store_location # http://git.io/-lVTIA

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
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

end
