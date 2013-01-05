NineteenWu::Application.configure do
  config.action_mailer.delivery_method = Settings.email.delivery_method.to_sym
  if Rails.env.development? || Rails.env.test?
    config.action_mailer.delivery_method = Rails.env.test? ? :test : :file
  end

  delivery_settings_key = "#{Settings.email.delivery_method}_settings"
  if delivery_settings = Settings.email[delivery_settings_key]
    config.action_mailer.send "#{delivery_settings_key}=", delivery_settings.symbolize_keys
  end

  config.action_mailer.default_url_options = {
    :host => Settings.email.host
  }

  ActionMailer::Base.default :from => Settings.email.from
end
