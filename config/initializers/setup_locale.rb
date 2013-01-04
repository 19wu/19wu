NineteenWu::Application.configure do |app|
  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
  config.time_zone = Settings.time_zone

  # Because of https://github.com/rails/rails/issues/8711
  #
  # time_zone changed here is not applied
  require 'active_support/core_ext/time/zones'
  zone_default = Time.find_zone!(app.config.time_zone)
  unless zone_default
    raise 'Value assigned to config.time_zone not recognized. ' \
    'Run "rake -D time" for a list of tasks for finding appropriate time zone names.'
  end
  Time.zone_default = zone_default

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
  # @see config/initializers/setup_locale_settings.rb
  config.i18n.default_locale = Settings.default_locale
end
