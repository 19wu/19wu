# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'event tickets' do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:ticket) { build(:event_ticket, event: event) }
  before { sign_in user }
  context 'with tickets' do
    before { ticket.save }
    scenario 'I can see it' do
      visit event_tickets_path(event)
      expect(page).to have_content(ticket.name)
      expect(page).to have_content(ticket.price)
      expect(page).to have_content(ticket.description)
    end
    scenario 'I can edit it' do
      visit event_tickets_path(event)
      within '.tickets-list' do
        click_on I18n.t('views.edit')
      end
      fill_in 'event_ticket[name]', with: "new #{ticket.name}"
      fill_in 'event_ticket[price]', with: 399
      fill_in 'event_ticket[description]', with: "description"
      click_on '更新门票'
      expect(page).to have_content("new #{ticket.name}")
      expect(page).to have_content(399)
      expect(page).to have_content('description')
    end
    scenario 'I can destroy it', js: true do
      visit event_tickets_path(event)
      page.execute_script("window.confirm = function(msg) { return true; }")
      click_on I18n.t('views.destroy')
      expect(page).not_to have_content(ticket.name)
      expect(page).not_to have_content(ticket.price)
      expect(page).not_to have_content(ticket.description)
    end
  end

  scenario 'I can create tickets' do
    visit new_event_ticket_path(event)
    fill_in 'event_ticket[name]', with: ticket.name
    fill_in 'event_ticket[price]', with: ticket.price
    fill_in 'event_ticket[description]', with: ticket.description
    click_on '新增门票'
    expect(page).to have_content(ticket.name)
    expect(page).to have_content(ticket.price)
    expect(page).to have_content(ticket.description)
  end
end
