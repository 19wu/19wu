NineteenWu::Application.configure do
  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
  config.time_zone = Settings.time_zone

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
  # @see config/initializers/setup_locale_settings.rb
  config.i18n.default_locale = Settings.default_locale
end
