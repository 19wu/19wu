class OrderFulfillmentMailer < ActionMailer::Base
  default from: Settings.email[:from]

  def notify_user_fulfilled(fulfillment)
    @fulfillment = fulfillment
    @order = @fulfillment.order
    @event = @order.event
    @user = @order.user
    mail(to: @user.email_with_login, subject: I18n.t('email.order.user.fulfilled.subject', title: @event.title, number: @order.number))
  end

  def notify_organizer_fulfilled(fulfillment)
    @fulfillment = fulfillment
    @order = @fulfillment.order
    @event = @order.event
    @user = @order.user
    mail(to: @event.user.email_with_login, subject: I18n.t('email.order.organizer.fulfilled.subject', title: @event.title, number: @order.number))
  end
end
