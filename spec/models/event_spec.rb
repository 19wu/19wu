# encoding: utf-8
require 'spec_helper'

describe Event do
  let(:event) { build :event }

  it "passes validation with all valid informations" do
    expect(event).to be_valid
  end

  context "fails validation" do
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
          before { event.slug = create(:group).slug }
          its(:valid?) { should be_false }
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

  describe '#participated_users.recent' do
    let(:event) { create(:event) }

    it 'sorts participants by join date' do
      first = create(:user)
      second = create(:user)

      EventParticipant.create({ :user_id => first.id, :event_id => event.id, :created_at => '2012-01-01' },
                              :without_protection => true)
      EventParticipant.create({ :user_id => second.id, :event_id => event.id, :created_at => '2012-01-02' },
                              :without_protection => true)

      event.participated_users.recent.should == [second, first]
    end

    it 'can limit the number of participants' do
      event.participated_users << create_list(:user, 2)
      event.participated_users.recent(1).should have(1).user
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

  describe '#history_url_text' do
    it 'should return string contains event date along with number of participated users' do
      event = create(:event, :start_time => Time.at(1368969404)) # Time.at(1368969404) == "2013-05-19 21:16:44 +0800"
      event.participated_users << create(:user)
      event.participated_users << create(:user)

      event.history_url_text.should == "2013-05-19 2人参加"
    end
  end
end
