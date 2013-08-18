require File.expand_path('../../spec_helper', __FILE__)

feature 'event page' do
  given(:content) {
    <<-MD
# title #

-   list
    MD
  }

  given(:event) { FactoryGirl.create(:event, :content => content, :user => login_user) }

  scenario 'I see the markdown formatted event content' do
    visit event_path(event)

    page.should have_selector('.event-body h1', :text => 'title')
    page.should have_selector('.event-body li', :text => 'list')
  end

  context 'with orders' do
    let(:orders) { create_list(:order_with_items, 5, event: event) }
    before { orders }
    scenario 'I see list of participants', js: true do
      visit event_path(event)
      page.should have_selector('.event-participants img.gravatar', :count => 5)
    end
  end
end
