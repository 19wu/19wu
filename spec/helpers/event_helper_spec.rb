# encoding: utf-8
require 'spec_helper'

describe EventHelper do
  describe '#time_merge' do
    let(:event) { build :event, start_time: "#{year}-12-30 08:00", end_time: "#{year}-12-30 10:00" }
    let(:year) { Time.zone.now.year }
    let(:next_year) { year + 1 }
    subject { helper.time_merge(event) }
    context 'when has not end time' do
      before { event.end_time = nil }
      context 'when year is current year' do
        it { should == '12月30日(一) 上午 08:00' }
      end
      context 'when year is not current year' do
        before { event.start_time = event.start_time.change(year: next_year) }
        it { should == "#{next_year}年12月30日(二) 上午 08:00" }
      end
    end
    context 'when has end time' do
      context 'when year is current year' do
        context 'when date is the same' do
          context 'when moon is the same' do
            it { should == '12月30日(一) 上午 08:00 - 10:00' }
          end
          context 'when moon is not the same' do
            before { event.end_time = event.end_time.change(hour: 15) }
            it { should == '12月30日(一) 上午 08:00 - 下午 03:00' }
          end
        end
        context 'when date is not the same' do
          before { event.end_time = event.end_time.change(day: 31) }
          it { should == '12月30日(一) 上午 08:00 - 12月31日(二) 上午 10:00' }
        end
      end
      context 'when year is not current year' do
        before do
          event.start_time = event.start_time.change(year: next_year)
          event.end_time = event.end_time.change(year: next_year)
        end
        context 'when date is the same' do
          context 'when moon is the same' do
            it { should == "#{next_year}年12月30日(二) 上午 08:00 - 10:00" }
          end
          context 'when moon is not the same' do
            before { event.end_time = event.end_time.change(hour: 15) }
            it { should == "#{next_year}年12月30日(二) 上午 08:00 - 下午 03:00" }
          end
        end
        context 'when date is not the same' do
          before { event.end_time = event.end_time.change(day: 31) }
          it { should == "#{next_year}年12月30日(二) 上午 08:00 - #{next_year}年12月31日(三) 上午 10:00" }
        end
      end
    end
  end

  describe '#group_event_path' do
    let(:event) { create :event }
    subject { helper.group_event_path(event) }
    context 'when event is the last' do
      it { should == "/#{event.group.slug}" }
    end
    context 'when event is not the last' do
      before do
        create :event, :slug => event.group.slug, :start_time => Time.now, :end_time => nil, user: event.user
      end
      it { should == "/events/#{event.id}" }
    end
  end

  describe '#event_follow_info' do
    before { helper.stub :current_user, nil }
    let(:event) { create :event }
    subject { helper.event_follow_info(event) }
    it { should eql [0, { false: '关注' , true: '已关注' }, false].to_json }
  end
end
