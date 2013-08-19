# encoding: utf-8
require 'spec_helper'

describe EventChange do
  describe 'send change to participants' do
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, user: user, title: '深圳Rubyist活动') }
    let!(:order1) { create(:order_with_items, event: event) }
    let!(:order2) { create(:order_with_items, event: event) }
    let(:change) { create(:event_change, event: event) }
    describe 'by email' do
      subject { ActionMailer::Base.deliveries.last }
      before do
        ChinaSMS.stub(:to)
        ActionMailer::Base.deliveries.clear
        change
      end
      its(:subject) { should eql '「重要」深圳Rubyist活动 变更通知' }
      its('body.decoded') { should match change.content }
    end
    describe 'by sms' do
      it 'should be success' do
        phones = [order2.user.phone, order1.user.phone].sort
        ChinaSMS.stub(:to).with(phones, I18n.t('sms.event.change', content: attributes_for(:event_change)[:content]))
        change
      end
    end
  end
end
