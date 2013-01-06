require File.expand_path('../../spec_helper', __FILE__)

feature 'user page' do

  given!(:bob) { create(:user, :login => 'bob') }
  background { sign_in }

  scenario "I see bob's profile page using /bob" do
    visit '/bob'
    page.should have_content 'bob'
  end
end
