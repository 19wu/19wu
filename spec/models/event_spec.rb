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
  end
end
