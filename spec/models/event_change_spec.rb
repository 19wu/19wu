# encoding: utf-8
require 'spec_helper'

describe EventChange do
  describe 'send change to participants' do
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, user: user, title: '深圳Rubyist活动') }
    let(:participant1) { create(:event_participant, :random_user, event: event) }
    let(:participant2) { create(:event_participant, :random_user, event: event) }
    let(:change) { create(:event_change, event: event) }
    before do
      [participant1, participant2]
    end
    describe 'by email' do
      subject { ActionMailer::Base.deliveries.last }
      before do
        ActionMailer::Base.deliveries.clear
        change
      end
      its(:subject) { should eql '「重要」深圳Rubyist活动 变更通知' }
      its('body.decoded') { should match change.content }
    end
    describe 'by sms' do
      it 'should be success' do
        ChinaSMS.stub(:to).with([participant1.user.phone, participant2.user.phone], I18n.t('sms.event.change', content: attributes_for(:event_change)[:content]))
        change
      end
    end
  end
end
