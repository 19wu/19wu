namespace :assets do
  # Because of config.assets.initialize_on_precompile = false,
  # must load i18n manually
  task :i18n_environment do
    require Rails.root.join('app/models/settings')
    I18n.locale = Settings.default_locale
    I18n.load_path += Dir[Rails.root.join('config/locales/*.yml')]
  end

  task :environment => :i18n_environment
end

