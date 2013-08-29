class UserMailer < ActionMailer::Base
  helper :event
  default from: Settings.email[:from]

  def welcome_email(user)
    mail(:to => user.email, :subject => I18n.t('email.welcome.subject'))
  end

  def invited_email(user)
    @user = user
    mail(:to => user.email, :subject => I18n.t('email.invited.subject', :login => user.login))
  end

  def notify_email(user, event)
    @user = user
    @event = event
    mail(:to => user.email, :subject => I18n.t('email.notify.subject', :title => event.title))
  end

  def reminder_email(user, event)
    @user = user
    @event = event
    mail(:to => user.email, :subject => I18n.t('email.reminder.subject'))
  end
end
