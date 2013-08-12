# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'event orders', js: true do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:ticket) { event.tickets.first }

  before do
    sign_in user
    ticket.update_attribute :price, 299
  end

  scenario 'I can create order' do
    event.update_attribute :tickets_quantity, 20

    visit event_path(event)
    within '.event-tickets' do
      select '1'
    end
    find('a', text: '购买').click

    expect(page).to have_content('您已经提交了订单，订单号为1，请尽快支付')
    expect(page).to have_content('使用支付宝支付')
  end

  scenario 'I want to buy tickets, but sold out' do
    event.update_attribute :tickets_quantity, 0

    visit event_path(event)

    expect(page).to have_selector('.sold-out')
  end
end
