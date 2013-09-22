# -*- coding: utf-8 -*-
class OrderRefundsController < ApplicationController
  include HasApiResponse
  before_filter :authenticate_user!, except: :alipay_notify
  before_filter :authorize_event!, only: [:submit]          # organizer
  before_filter :authorize_refund!, only: [:index, :archive] # 19wu admin
  skip_before_filter  :verify_authenticity_token, :alipay_notify

  def submit
    order = @event.orders.find(params[:id])
    @refund = order.refunds.submit(params.fetch(:refund).permit(:amount, :reason))
  end

  def index
    @refund_batches = RefundBatch.where(status: 'pending')
    @refunds = EventOrderRefund.where(status: 'submited', refund_batch_id: nil)
  end

  # 19屋管理员获取退款批次号
  def archive
    @refunds = EventOrderRefund.where(status: 'submited', refund_batch_id: nil)
    unless @refunds.empty?
      refund_batch = RefundBatch.create
      logger.info refund_batch.errors.full_messages
      @refunds.update_all(refund_batch_id: refund_batch.id)
    end
    redirect_to refunds_path
  end

  def alipay_notify
    notify_params = params.except(*request.path_parameters.keys)
    if Alipay::Notify.verify?(notify_params)
      EventOrder.transaction do
        refund_batch = RefundBatch.where(batch_no: params[:batch_no]).first
        refund_batch.complete! if params['success_num'].to_i == refund_batch.refunds.size
        params['result_details'].split('#').each do |item|
          # 交易号^退款金额^处理结果$退费账号^退费账户 ID^退费金额^处理结果
          # 2010031906272929^80^SUCCESS$jax_chuanhang@alipay.com^2088101003147483^0.01^SUCCESS
          trade_no, amount, result = item.split(/\^|\$/)
          if result.downcase == 'success'
            order = EventOrder.where(trade_no: trade_no).first
            refund = order.refunds.refunding
            refund.refund!
          end
        end
      end
      render text: 'success'
    else
      render text: 'fail'
    end
  end

  private
  def authorize_refund!
    authorize! :refund, EventOrder
  end
end
