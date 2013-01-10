require File.expand_path('../../../spec_helper', __FILE__)

describe 'events/_event.html.slim' do
  let(:event) { build_stubbed(:event, :markdown) }
  let(:current_user) { build(:user) }

  before { render :partial => 'events/event', :locals => { :event => event, :current_user => current_user } }
  subject { rendered }

  it { should have_content(event.title) }
  it { should include(event.content_html) }
  it { should include(event.location_guide_html) }
end
