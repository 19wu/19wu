class EventMailer < ActionMailer::Base
  default from: Settings.email[:from]

  def change_email(change, emails)
    @change = change
    @event = change.event
    mail(to: emails.shift, bcc: emails, subject: I18n.t('email.event.change.subject', title: @event.title))
  end
end
