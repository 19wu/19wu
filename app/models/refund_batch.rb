class RefundBatch < ActiveRecord::Base
  has_many :refunds, class_name: 'EventOrderRefund'
  validates :batch_no, presence: true

  before_validation do
    self.batch_no ||= Random.rand(100000..999999).to_s # 生成批次号，避免重复退款
  end

  state_machine :status, :initial => :pending do
    state :pending, :completed

    event :complete do
      transition :pending => :completed
    end
  end
end
