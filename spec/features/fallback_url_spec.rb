require 'spec_helper'

feature "Fallback Url" do
  given(:event) { create :event, slug: 'ruby-conf-china' }
  before do
    event.update_attributes! slug: 'rubyconfchina'
  end
  scenario "I can use origin url to visit event page" do
    visit '/ruby-conf-china'
    page.should have_content event.title
  end
end
