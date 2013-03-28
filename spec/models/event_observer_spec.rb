# encoding: utf-8
require 'spec_helper'

describe EventObserver do
  context 'create' do
    let(:user) { create :user }
    let(:event) { create :event, user: user }
    let(:participant) { create :user }
    let(:new_event) { create :event, user: user, title: 'SH Ruby' }
    subject { ActionMailer::Base.deliveries.last }
    before do
      participant.follow event.group
      ActionMailer::Base.deliveries.clear
      new_event
    end
    it 'should notify all followers' do
      subject.subject.should eql '19屋新活动 - SH Ruby'
      subject.body.decoded.should match /http:\/\/localhost:3000\/rubyconf/
    end
  end
  context 'save' do
    subject { create :event }
    its(:group) { should_not be_nil }
  end
  context 'update' do
    subject { create :event }
    describe 'orgin group' do
      context 'has not events' do
        it 'should be destroy' do
          subject
          expect do
            subject.update_attributes! :slug => 'rubyconf'
          end.not_to change{Group.count}
        end
      end
      context 'still has events' do
        before { create :event, user: subject.user }
        it 'should not be destroy' do
          expect do
            subject.update_attributes! :slug => 'rubyconf'
          end.to change{Group.count}.by(1)
        end
      end
    end
  end
end
