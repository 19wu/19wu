class EventMailer < ActionMailer::Base
  default from: Settings.email[:from]

  def change_email(change, user)
    @change = change
    @event = change.event
    @user = user
    mail(to: user.email_with_login, subject: I18n.t('email.event.change.subject', title: @event.title))
  end
end
