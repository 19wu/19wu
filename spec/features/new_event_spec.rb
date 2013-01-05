require 'spec_helper'

feature 'new event' do
  let(:user) { create :user }
  let(:submit) { I18n.t('helpers.submit.event.create') }
  let(:flash) { I18n.t('flash.events.created') }
  let(:attributes) { attributes_for(:event, :markdown) }
  before { sign_in }

  scenario 'I create the event with valid attributes' do
    visit new_event_path

    fill_in 'event_title', with: attributes[:title]
    fill_in 'event_compound_start_time_attributes_date', with: attributes[:start_time].split(' ').first
    fill_in 'event_location', with: attributes[:location]
    fill_in 'event_content', with: attributes[:content]

    click_button submit
    expect(page).to have_content(flash)
  end
end
