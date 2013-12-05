NineteenWu::Application.configure do
  config.action_mailer.delivery_method = Settings.email.delivery_method.to_sym

  delivery_settings_key = "#{Settings.email.delivery_method}_settings"
  if delivery_settings = Settings.email[delivery_settings_key]
    config.action_mailer.send "#{delivery_settings_key}=", delivery_settings.symbolize_keys
    ActionMailer::Base.send "#{delivery_settings_key}=", delivery_settings.symbolize_keys # fix for exception notification
  end

  config.action_mailer.default_url_options = {
    :host => Settings.host
  }
  ActionMailer::Base.default_url_options = config.action_mailer.default_url_options # http://git.io/biMyZA

  ActionMailer::Base.default :from => Settings.email.from
end
