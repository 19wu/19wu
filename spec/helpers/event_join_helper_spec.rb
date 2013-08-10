# encoding: utf-8
require 'spec_helper'

describe EventJoinHelper do
  let(:user) { build :user }
  let(:event) { double 'event' }
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
end
