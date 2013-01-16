require 'spec_helper'

describe EventUsership do
  let(:event) { FactoryGirl.create(:event) }
  let(:user) { FactoryGirl.create(:user) }

  it "success save" do
    attendee =  Event.find(event.id).attendees.build(:user_id => user.id)
    expect(attendee.save).to be_true
    attendee.event_id.should == event.id
    attendee.user_id.should == user.id
  end
end
