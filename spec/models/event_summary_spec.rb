require 'spec_helper'

describe EventSummary do
  it "must have a content" do
    summary = EventSummary.new(event_id: create(:event).id)
    expect(summary.valid?).to be_false
  end

  it "have a content with a minimum lenght of 10" do
    summary = EventSummary.new(event_id: create(:event).id, content: "12345")
    expect(summary.valid?).to be_false
  end
end