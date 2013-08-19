# coding: utf-8
require 'spec_helper'

describe Event do
  let(:event) { build :event }

  it "passes validation with all valid informations" do
    expect(event).to be_valid
  end

  context "validation" do
    it "with a blank title" do
      event.title = ''
      expect(event.save).to be_false
    end

    it "with a blank start_time" do
      event.start_time = ''
      expect(event.save).to be_false
    end

    it "with a blank location" do
      event.location = ''
      expect(event.save).to be_false
    end

    it "with start_time > end_time" do
      event.start_time = "2012-12-31 08:00:51"
      event.end_time = "2012-12-31 08:00:50"
      expect(event.save).to be_false
    end

    describe 'slug' do
      subject { event }
      context 'is blank' do
        before { event.slug = '' }
        its(:valid?) { should be_false }
      end
      context 'has not been taken' do
        before { event.slug = 'rubyconfchina' }
        its(:valid?) { should be_true }
      end
      context 'has been taken' do
        context 'by other group' do
          let(:group) { create(:group) }
          before { event.slug = group.slug }
          context 'is not a collaborator' do
            its(:valid?) { should be_false }
          end
          context 'is a collaborator' do
            let(:partner) { create(:user) }
            let(:collaborator) { create(:group_collaborator, group_id: group.id, user_id: partner.id) }
            before do
              collaborator
              event.user = partner
            end
            its(:valid?) { should be_true }
          end
        end
        context 'by other user' do
          before { event.slug = event.user.login }
          its(:valid?) { should be_false }
        end
        context 'by routes' do
          before { event.slug = 'photos' }
          its(:valid?) { should be_false }
        end
      end
    end
  end

  describe 'content_html' do
    context 'when content is "# title #"' do
      subject { build :event, :content => '# title #' }
      its(:content_html) { should include('<h1>title</h1>') }
    end
  end

  describe 'location_guide_html' do
    context 'when content is "# map #"' do
      subject { build :event, :location_guide => '# map #' }
      its(:location_guide_html) { should include('<h1>map</h1>') }
    end
  end

  describe '#ordered_users.recent' do
    let(:event) { create(:event) }
    let!(:order1) { create(:order_with_items, event: event) }
    let!(:order2) { create(:order_with_items, event: event) }
    it 'sorts users by join date' do
      event.ordered_users.recent.should == [order2.user, order1.user]
    end
    it 'can limit the number of users' do
      event.ordered_users.recent(1).should have(1).user
    end
  end

  describe '#sibling_events' do
    it 'should return all events under the same group except itself' do
      user   = create(:user)
      event1 = create(:event, :user => user)
      event2 = create(:event, :user => user)

      event1.sibling_events.should == [event2]
    end
  end

  describe '#upcoming' do
    it 'returns only events start on tomorrow' do
      create(:event, :slug => 'e1', :start_time => '2013-05-25')
      create(:event, :slug => 'e2', :start_time => '2013-05-27')
      event_tomorrow = create(:event, :slug => 'e3', :start_time => '2013-05-26')

      today = Time.zone.parse('2013-05-25')
      Event.upcoming(today).should == [event_tomorrow]
    end
  end

  describe '#remind_participants' do
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, start_time: 1.day.since, end_time: nil, user: user) }
    let(:order) { create(:order_with_items, event: event) }
    subject { ActionMailer::Base.deliveries.last }

    before do
      order
      ActionMailer::Base.deliveries.clear
    end

    it 'should remind all participants' do
      Event.remind_participants
      subject.subject.should eql '19屋活动提醒'
      subject.to.should eql [order.user.email]
    end
  end

  describe '#started?' do
    subject { event }
    context '2 days ago' do
      before { event.update_attribute :start_time, 2.day.ago }
      its(:started?) { should be_true }
    end
    context '1 day later' do
      before { event.update_attribute :start_time, 1.day.since }
      its(:started?) { should be_false }
    end
  end

  describe '#finished?' do
    subject { event }
    context '2 days ago' do
      before { event.update_attribute :end_time, 2.day.ago }
      its(:finished?) { should be_true }
    end
    context '1 day later' do
      before { event.update_attribute :end_time, 1.day.since }
      its(:finished?) { should be_false }
    end
  end

  describe '#show_summary?' do
    let(:user) { create(:user) }

    it 'should return true if it has a summary' do
      event1 = create(:event, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      event2 = create(:event, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      event3 = create(:event, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:event_summary, event: event2)

      event2.show_summary?.should == true
    end

    it 'should return ture if it has no summary and it is not finished and its group has an event with summary' do
      event1 = create(:event, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      event2 = create(:event, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      event3 = create(:event, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:event_summary, event: event2)

      event3.show_summary?.should == true
    end

    it 'should return false if it is finished and has not summary' do
      event1 = create(:event, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      event2 = create(:event, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      event3 = create(:event, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:event_summary, event: event1)

      event2.show_summary?.should == false
    end

    it 'should return false if is not finished and none of its siblings has a summary' do
      event1 = create(:event, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      event2 = create(:event, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      event3 = create(:event, user: user, start_time: 1.day.since, end_time: 2.day.since)

      event3.show_summary?.should == false
    end
  end

  describe '#checkin_code' do
    it "should return the checkin code of event" do
      event = create(:event, slug: "ruby", created_at: '2013-05-05 23:12:08')
      expect(event.checkin_code).to eq '328'
    end
  end

  describe 'tickets' do
    subject { event.tap(&:save) }
    its('tickets.size') { should eql 1 }
  end
end
