NineteenWu::Application.config.middleware.use :FallbackUrlRedirector

if Rails.env.production?
  NineteenWu::Application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[19wu] ",
      :sender_address => Settings.email.from,
      :exception_recipients => Settings.email.exception_recipients
    }
end
