require File.expand_path('../../../spec_helper', __FILE__)

describe 'events/_event.html.slim' do
  let(:event) { build_stubbed(:event, :markdown) }

  before { render :partial => 'events/event', :locals => { :event => event } }
  subject { rendered }

  it { should have_content(event.title) }
  it { should include(event.content_html) }
end
