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
    subject { helper.init_join(event) }
    before do
      helper.stub(:current_user).and_return(user)
      event.stub(:has?).and_return(true)
    end
    it { should eql "user.joined=true;labels=#{t('views.join.state').to_json};titles=#{t('views.join.title').to_json}" }
  end
end
