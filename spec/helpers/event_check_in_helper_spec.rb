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
      end
      context 'with end_time' do
        before do
          end_time = mock('end_time')
          end_time.should_receive(:past?).and_return(true)
          event.stub(:end_time).and_return(end_time)
        end
        it { should eql "outdate=true;message=\"#{t('flash.participants.checkin_welcome')}\"" }
      end
      context 'without end_time' do
        before do
          event.stub(:end_time).and_return(nil)
          start_time = mock('start_time')
          start_time.should_receive(:to_date).and_return(start_time)
          start_time.should_receive(:past?).and_return(true)
          event.stub(:start_time).and_return(start_time)
        end
        it { should eql "outdate=true;message=\"#{t('flash.participants.checkin_welcome')}\"" }
      end
    end
  end
end
