require 'spec_helper'

describe Group do
  describe "#last_event_with_summary" do
    let(:user) { create(:user, :confirmed) }
    let(:event1) { create(:event, user: user, start_time: 6.day.ago, end_time: 5.day.ago) }
    let(:event2) { create(:event, user: user, start_time: 4.day.ago, end_time: 3.day.ago) }
    let(:event3) { create(:event, user: user, start_time: 2.day.ago, end_time: 1.day.ago) }

    it "should reture the last event with summary" do
      create(:event_summary, event: event1)
      create(:event_summary, event: event2)

      event1.group.last_event_with_summary.should == event2
    end

    it "should return nil if none of the events has a summary" do
      event1.group.last_event_with_summary.should == nil
    end
  end
end
