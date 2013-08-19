# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'event tickets' do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:ticket) { event.tickets.first }
  before { sign_in user }
  context 'with tickets' do
    scenario 'I can see it' do
      visit event_tickets_path(event)
      expect(page).to have_content(ticket.name)
      expect(page).to have_content(ticket.price)
      expect(page).to have_content(I18n.t('simple_form.options.event_ticket.require_invoice')[ticket.require_invoice])
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
      visit event_tickets_path(ticket.event)
      stub_confirm
      click_on I18n.t('views.destroy')
      within '.tickets-list' do
        expect(page).not_to have_content(ticket.name)
        expect(page).not_to have_content(ticket.price)
        expect(page).not_to have_content("总票数：#{event.tickets_quantity}")
      end
    end
  end

  scenario 'I can create tickets' do
    visit new_event_ticket_path(event)
    fill_in 'event_ticket[name]', with: ticket.name
    fill_in 'event_ticket[price]', with: ticket.price
    fill_in 'event_ticket[description]', with: ticket.description
    fill_in 'event_ticket[tickets_quantity]', with: 400
    click_on '新增门票'
    expect(page).to have_content(ticket.name)
    expect(page).to have_content(ticket.price)
    expect(page).to have_content(ticket.description)
    expect(page).to have_content("总票数：400")
  end
end
