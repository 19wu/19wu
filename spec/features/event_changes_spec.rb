# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'event changes' do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:content) { attributes_for(:event_change)[:content] }
  before { sign_in user }
  scenario 'I can create changes' do
    visit new_event_change_path(event)
    fill_in 'event_change[content]', with: content
    click_on '新增变更'
    page.should have_content(content)
  end
end
