# encoding: utf-8
require 'spec_helper'

describe EventCheckInHelper do
  let(:user) { build :user }
  let(:event) { mock 'event' }
  describe '#checked_in?' do
    subject { helper.checked_in?(event) }
    context 'without current_user' do
      before { helper.stub(:current_user).and_return(nil) }
      it { should eql false }
    end
    context 'with current_user' do
      before { helper.stub(:current_user).and_return(user) }
      context 'checkin event' do
        before { user.should_receive(:checked_in?).and_return(true) }
        it { should eql true }
      end
      context 'did not checkin event' do
        before { user.should_receive(:checked_in?).and_return(false) }
        it { should eql false }
      end
    end
  end
  describe '#init_checkin' do
    subject { helper.init_checkin(event) }
    context 'without current_user' do
      before { helper.stub(:current_user).and_return(nil) }
      it { should eql '' }
    end
    context 'with current_user' do
      before do
        helper.stub(:current_user).and_return(user)
        helper.stub(:checked_in?).and_return(user)
        outdate = mock('outdate')
        outdate.should_receive(:past?).and_return(true)
        event.stub(:end_time).and_return(outdate)
      end
      it { should eql "outdate=true;message='#{t('flash.participants.checkin_welcome')}'" }
    end
  end
end
