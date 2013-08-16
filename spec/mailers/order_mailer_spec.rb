require "spec_helper"

describe OrderMailer do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, require_invoice: true, event: event) }

  describe "notify" do
    describe "user" do
      describe "order created" do
        subject { OrderMailer.notify_user_created(order, user) }
        its(:subject) { should eql '您在19屋的订单下单成功' }
        its(:from) { should eql [Settings.email.from] }
        its(:to) { should eql [user.email] }
        its('body.decoded') { should match '发票将快递到以下地址' }
      end
    end
  end

end
