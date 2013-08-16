require "spec_helper"

describe OrderMailer do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, require_invoice: true, event: event) }

  describe "notify" do
    describe "user" do
      describe "order created" do
        subject { OrderMailer.notify_user_created(order) }
        its(:subject) { should eql '您在19屋的订单下单成功' }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [order.user.email] }
        its('body.decoded') { should match '收货人信息' }
      end
      describe "order paid" do
        subject { OrderMailer.notify_user_paid(order) }
        its(:subject) { should eql "订单 #{order.id} 完成支付" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [order.user.email] }
        its('body.decoded') { should match '我们已收到您支付的款项' }
      end
    end

    describe "organizer" do
      describe "order created" do
        subject { OrderMailer.notify_organizer_created(order) }
        its(:subject) { should eql "#{event.title} 订单 #{order.id}，#{order.user.login} 下单" }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [event.user.email] }
        its('body.decoded') { should match '刚刚新增了订单' }
      end
    end
  end

end
