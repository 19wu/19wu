class OrderRefundsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!, only: [:submit]          # organizer
  before_filter :authorize_refund!, only: [:index, :archive] # 19wu admin

  def submit
    order = @event.orders.find(params[:id])
    @refund = order.refunds.submit(params.require(:refund).permit(:amount, :reason))
  end

  def index
    authorize! :refund, EventOrder
    @refund_batches = RefundBatch.where(status: 'pending')
    @refunds = EventOrderRefund.where(status: 'submited', refund_batch_id: nil)
  end

  def archive
    @refunds = EventOrderRefund.where(status: 'submited', refund_batch_id: nil)
    unless @refunds.empty?
      refund_batch = RefundBatch.create
      logger.info refund_batch.errors.full_messages
      @refunds.update_all(refund_batch_id: refund_batch.id)
    end
    redirect_to refunds_path
  end

  private
  def authorize_refund!
    authorize! :refund, EventOrder
  end
end
