class UserMailer < ActionMailer::Base
  default from: Settings.email[:from]

  def welcome_email(user)
    mail(:to => user.email, :subject => I18n.t('email.welcome.subject')).deliver
  end

  def invited_email(user)
    mail(:to => user.email, :subject => I18n.t('email.invited.subject', :login => user.login)).deliver
  end
end
