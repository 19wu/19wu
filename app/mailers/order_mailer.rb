class OrderMailer < ActionMailer::Base
  include AlipayGeneratable
  default from: Settings.email[:from]

  def notify_user_created(order)
    @order = order
    @event = order.event
    @user = order.user
    @pay_link = generate_pay_link_by_order(order)
    mail(to: @user.email_with_login, subject: I18n.t('email.order.user.created.subject')).deliver
  end

  def notify_organizer_created(order)
    @order = order
    @event = order.event
    @user = order.user
    mail(to: @event.user.email_with_login, subject: I18n.t('email.order.organizer.created.subject', title: @event.title, id: @order.id, login: @user.login )).deliver
  end

  def notify_user_paid(order)
    @order = order
    @event = order.event
    @user = order.user
    mail(to: @user.email_with_login, subject: I18n.t('email.order.user.paid.subject', id: order.id)).deliver
  end

  def notify_organizer_paid(order)
    @order = order
    @event = order.event
    @user = order.user
    mail(to: @event.user.email_with_login, subject: I18n.t('email.order.organizer.paid.subject', title: @event.title, id: @order.id, login: @user.login )).deliver
  end
end
