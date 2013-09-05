# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'group collaborators', js: true do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:partner) { create(:user, :confirmed) }
  given(:collaborator) { create(:group_collaborator, group_id: event.group.id, user_id: partner.id) }
  context 'as a group creator sign in' do
    before { sign_in user }
    scenario 'I can see the collaborators menu' do
      visit event_path(event)
      page.should have_content(I18n.t('views.groups.collaborators'))
    end
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
        click_on I18n.t('helpers.submit.add')
        within '.list' do
          page.should have_content(partner.login)
        end
      end
    end
  end
  context 'as a collaborator sign in' do
    before do
      collaborator
      sign_in partner
    end
    scenario 'I can not see the collaborators menu' do
      visit event_path(event)
      page.should_not have_content(I18n.t('views.groups.collaborators'))
    end
    scenario 'I can update event' do
      visit edit_event_path(event)
      fill_in 'event_title', with: 'new event title'
      click_on '更新活动'
      page.should have_content(I18n.t('flash.events.updated'))
    end
  end
end
