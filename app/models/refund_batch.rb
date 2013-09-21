# -*- coding: utf-8 -*-
class RefundBatch < ActiveRecord::Base
  has_many :refunds, class_name: 'EventOrderRefund', dependent: :nullify
  validates :batch_no, presence: true

  before_validation do
    self.batch_no ||= Alipay::Utils.generate_batch_no # 生成批次号，避免重复退款
  end

  def refund_link
    data = self.refunds.map do |refund|
      {
        trade_no: refund.order.trade_no,
        amount:   refund.amount,
        reason:   refund.reason
      }
    end
    options = {
        batch_no:   self.batch_no,
        data:       data,
        notify_url: Rails.application.routes.url_helpers.refunds_alipay_notify_url(host: Settings.host)
    }
    logger.info data
    Alipay::Service.create_refund_url(options)
  end

  state_machine :status, :initial => :pending do
    state :pending, :completed

    event :complete do
      transition :pending => :completed
    end
  end
end
