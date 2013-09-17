class OrderRefundsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!, only: [:submit]

  def submit
    order = @event.orders.find(params[:id])
    @refund = order.refunds.submit(params.require(:refund).permit(:amount, :reason))
  end
end
