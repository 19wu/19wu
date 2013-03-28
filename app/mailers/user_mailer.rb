class UserMailer < ActionMailer::Base
  helper :event
  default from: Settings.email[:from]

  def welcome_email(user)
    mail(:to => user.email, :subject => I18n.t('email.welcome.subject')).deliver
  end

  def invited_email(user)
    mail(:to => user.email, :subject => I18n.t('email.invited.subject', :login => user.login)).deliver
  end

  def notify_email(user, event)
    @user = user
    @event = event
    mail(:to => user.email, :subject => I18n.t('email.notify.subject', :title => event.title)).deliver
  end
end
