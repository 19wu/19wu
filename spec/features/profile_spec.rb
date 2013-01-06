require File.expand_path('../../spec_helper', __FILE__)

feature 'profile settings' do
  given(:expected_flash) {
    I18n.t('flash.profiles.updated')
  }

  background do
    sign_in
  end

  background do
    visit profile_path
  end

  scenario "I update my profile" do
    fill_in 'profile_name', :with => '19wu'
    fill_in 'profile_website', :with => 'http://19wu.com'
    fill_in 'profile_phone', :with => '195195195'
    fill_in 'profile_bio', :with => '**Launch your event now**'

    find('.btn-primary').click

    page.should have_content(expected_flash)
  end
end
