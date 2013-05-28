require File.expand_path('../../spec_helper', __FILE__)

feature 'event collaborators', js: true do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:partner) { create(:user) }
  given(:collaborator) { create(:group_collaborator, group_id: event.group.id, user_id: partner.id) }
  before { sign_in user }
  context 'with a collaborator' do
    before do
      collaborator
      visit event_collaborators_path(event_id: event.id)
    end
    scenario 'I see the collaborator' do
      within '.collaborators-list' do
        page.should have_content(partner.login)
      end
    end
    scenario 'I can destroy the collaborator' do
      within '.collaborators-list' do
        find('.text-error').click
        page.should_not have_content(partner.login)
      end
    end
  end
  scenario 'I can add a collaborator' do
    visit event_collaborators_path(event_id: event.id)
    within '.collaborators-list' do
      find('input').set partner.login
      find('.typeahead.dropdown-menu li').click
      click_on '增加'
      page.should have_content(partner.login)
    end
  end
end
