require 'spec_helper'

feature "Landing Page" do
  scenario "I see the sign up form in landing page" do
    visit root_path
    page.should have_selector('form#new_user')
  end
end
