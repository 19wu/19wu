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
        create :event, :slug => event.group.slug, :start_time => 9.days.since, :end_time => nil, user: event.user
      end
      it { should == "/events/#{event.id}" }
    end
  end

  describe '#group_event_followers_path' do
    let(:event) { create :event }
    subject { helper.group_event_followers_path(event) }
    context 'when event is the last' do
      it { should == "/#{event.group.slug}/followers" }
    end
    context 'when event is not the last' do
      before do
        create :event, :slug => event.group.slug, :start_time => 9.days.since, :end_time => nil, user: event.user
      end
      it { should == "/events/#{event.id}/followers" }
    end
  end

  describe '#event_follow_info' do
    before { helper.stub current_user: nil }
    let(:event) { create :event }
    subject { helper.event_follow_info(event) }
    it { should eql [0, { false: '关注' , true: '已关注' }, false].to_json }
  end

  describe '#history_url_text' do
    let(:event) { create(:event, :start_time => Time.at(1368969404)) } # Time.at(1368969404) == "2013-05-19 21:16:44 +0800"
    let!(:order1) { create(:order_with_items, event: event) }
    let!(:order2) { create(:order_with_items, event: event) }
    subject { history_url_text(event) }
    it { should eql "2013-05-19 " + I18n.t('views.history.participants', number: 2) }
  end

  describe '#build_summary_title' do
    let(:user) { create(:user) }

    it 'should return t("views.summary") if it has a summary' do
      event1 = create(:event, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      event2 = create(:event, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      event3 = create(:event, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:event_summary, event: event2)

      build_summary_title(event2).should == I18n.t("views.summary")
    end

    it 'should return I18n.t("views.previous_summary") along with the date of the last event with summary' do
      event1 = create(:event, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      event2 = create(:event, user: user, start_time:  Time.at(1368969404), end_time: 1.day.since) # Time.at(1368969404) == "2013-05-19 21:16:44 +0800"
      event3 = create(:event, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:event_summary, event: event2)

      build_summary_title(event3).should == I18n.t("views.previous_summary") + '(20130519)'
    end
  end

  describe '#build_summary_content' do
    let(:user) { create(:user) }

    it 'should return content of its summary if it has a summary' do
      event1 = create(:event, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      event2 = create(:event, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      event3 = create(:event, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:event_summary, event: event2)

      build_summary_content(event2).should == create(:event_summary, event: event1).content_html
    end

    it 'should return content of summary of the last event with summary in group' do
      event1 = create(:event, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      event2 = create(:event, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      event3 = create(:event, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:event_summary, event: event2)

      build_summary_content(event3).should == event2.event_summary.content_html
    end
  end
end
