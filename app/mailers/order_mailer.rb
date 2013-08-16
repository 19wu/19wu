class OrderMailer < ActionMailer::Base
  include AlipayGeneratable
  default from: Settings.email[:from]

  def notify_user_created(order, user)
    @order = order
    @event = order.event
    @user = user
    @pay_link = generate_pay_link_by_order(order)
    mail(to: user.email_with_login, subject: I18n.t('email.order.user.created.subject'))
  end
end
