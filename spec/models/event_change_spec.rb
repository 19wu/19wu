require 'spec_helper'

describe EventChange do
  describe 'send email to participants' do
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, user: user, title: '深圳Rubyist活动') }
    let(:participant1) { create(:event_participant, :random_user, event: event) }
    let(:participant2) { create(:event_participant, :random_user, event: event) }
    let(:change) { create(:event_change, event: event) }
    subject { ActionMailer::Base.deliveries.last }
    before do
      [participant1, participant2]
      ActionMailer::Base.deliveries.clear
      change
    end
    its(:subject) { should eql '「重要」深圳Rubyist活动 变更通知' }
    its('body.decoded') { should match change.content }
  end
end
