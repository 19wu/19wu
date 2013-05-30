require 'spec_helper'

feature "add event summary to an event" do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:submit) { I18n.t('helpers.submit.create', model: I18n.t('activerecord.models.event_summary')) }
  
  background do
    sign_in user
  end

  scenario "submit with valid data" do
    visit new_event_summary_path(event)
    fill_in :event_summary_content, with: "I really like this project, I learned a lot and growed my self."
    click_button submit

    page.should have_content 'I really like this project'
  end

  scenario "submit with invalid data" do
    visit new_event_summary_path(event)
    fill_in :event_summary_content, with: "broken!"
    click_on submit

    page.should have_content I18n.t('simple_form.error_notification.default_message')
  end
end
