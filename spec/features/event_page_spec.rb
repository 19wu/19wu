require File.expand_path('../../spec_helper', __FILE__)

feature 'event page' do
  given(:content) {
    <<-MD
# title #

-   list
    MD
  }

  given(:event) { create :event, :content => content }

  scenario 'I see the markdown formatted event content' do
    visit event_path(event)

    page.should have_selector('.event-body h1', :text => 'title')
    page.should have_selector('.event-body li', :text => 'list')
  end
end
