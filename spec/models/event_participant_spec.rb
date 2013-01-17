require 'spec_helper'

describe EventParticipant do
  let(:event) { FactoryGirl.create(:event) }
  let(:user) { FactoryGirl.create(:user) }

  it "success save" do
    participant =  Event.find(event.id).participants.build(:user_id => user.id)
    expect(participant.save).to be_true
    participant.event_id.should == event.id
    participant.user_id.should == user.id
  end
end
