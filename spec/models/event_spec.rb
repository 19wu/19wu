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
end
