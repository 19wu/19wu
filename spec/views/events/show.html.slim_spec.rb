require File.expand_path('../../../spec_helper', __FILE__)

describe 'events/show.html.slim' do
  let(:event) { create(:event, :markdown) }
  let(:current_user) { build_stubbed(:user) }
  before do
    controller.stub(:current_user) { current_user }
    assign :event, event
    render :template => 'events/show', :locals => { :current_user => current_user}
  end
  subject { rendered }
  it { should have_content(event.title) }
  it { should include(event.content_html) }
  it { should include(event.location_guide_html) }
end
