if Rails.env.production?
  NineteenWu::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[19wu] ",
    :sender_address => Settings.email.from,
    :exception_recipients => %W{#{Settings.email.from}}
end
