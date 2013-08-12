module AlipayGeneratable
  extend ActiveSupport::Concern

  def generate_pay_link_by_order(order)
    event = order.event
    options = {
        :out_trade_no      => order.id,
        :subject           => "#{event.title} 门票",
        :logistics_type    => 'DIRECT',
        :logistics_fee     => '0',
        :logistics_payment => 'SELLER_PAY',
        :price             => order.price,
        :quantity          => 1,
        :discount          => 0,
        :return_url        => alipay_done_user_order_url(order), # localhost isn't work http://bit.ly/1cwKbsw
        :notify_url        => alipay_notify_user_order_url(order)
    }
    Alipay::Service.create_direct_pay_by_user_url(options)
  end

  included { hide_action :generate_pay_link_by_order }
end
