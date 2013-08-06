# encoding: utf-8
require 'spec_helper'

describe EventJoinHelper do
  let(:user) { build :user }
  let(:event) { mock 'event' }
  describe '#joined?' do
    subject { helper.joined?(event) }
    context 'without current_user' do
      before { helper.stub(:current_user).and_return(nil) }
      it { should eql false }
    end
    context 'with current_user' do
      before { helper.stub(:current_user).and_return(user) }
      context 'joined event' do
        before { user.should_receive(:joined?).and_return(true) }
        it { should eql true }
      end
      context 'did not join event' do
        before { user.should_receive(:joined?).and_return(false) }
        it { should eql false }
      end
    end
  end
  describe '#init_join' do
    let(:start_time) { mock('start_time') }
    let(:event_end?) { false }
    subject { helper.init_join(event) }
    before do
      helper.stub(:current_user).and_return(user)
      event.stub(:has?).and_return(true)
      start_time.should_receive(:past?).and_return(event_end?)
      event.stub(:start_time).and_return(start_time)
    end
    it { should eql "user.joined=true;labels=#{t('views.join.state').to_json};titles=#{t('views.join.title').to_json}" }
    context 'event started' do
      let(:event_end?) { true }
      it { should eql "user.joined=\"event_end\";labels=#{t('views.join.state').to_json};titles=#{t('views.join.title').to_json}" }
    end
  end
end
