require 'spec_helper'

describe EventParticipant do
  let(:event) { FactoryGirl.create(:event) }
  let(:user) { FactoryGirl.create(:user) }
  let(:participant) { create(:event_participant, event_id: event.id, user_id: user.id) }

  it "success save" do
    participant =  Event.find(event.id).participants.build(:user_id => user.id)
    expect(participant.save).to be_true
    participant.event_id.should == event.id
    participant.user_id.should == user.id
  end

  it "success check in" do
    participant =  Event.find(event.id).participants.build(:user_id => user.id)
    participant.joined = true
    expect(participant.save).to be_true
    participant.joined.should be_true
  end
end
