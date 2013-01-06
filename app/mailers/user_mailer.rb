class UserMailer < ActionMailer::Base
  default from: Settings.email[:from]

  def welcome_email(user)
    mail(:to => user.email, :subject => I18n.t('email.welcome.subject')).deliver
  end
end
