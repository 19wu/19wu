# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'event orders', js: true do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:ticket) { event.tickets.first }
  given(:address_attributes) { attributes_for(:shipping_address) }

  before do
    sign_in user
    event.update_attribute :tickets_quantity, 20
  end

  context 'with user name and phone' do
    before { user.profile.update_attribute :name, 'saberma' }
    scenario 'I can create order' do
      ticket.update_attribute :price, 299
      visit event_path(event)
      within '.event-tickets' do
        select '1'
      end
      find('a', text: '购买').click
      expect(page).to have_content('您已经提交了订单，订单号为1，请尽快支付')
      expect(page).to have_content('使用支付宝支付')
    end

    scenario 'I buy a ticket with invoice' do
      ticket.update_attributes require_invoice: true, price: 299
      visit event_path(event)
      within '.event-tickets' do
        select '1'
      end
      find('a', text: '购买').click
      fill_in 'invoice_title', with: address_attributes[:invoice_title]
      select ChinaCity.get(address_attributes[:province])
      select ChinaCity.get(address_attributes[:city])
      select ChinaCity.get(address_attributes[:district])
      fill_in 'address', with: address_attributes[:address]
      fill_in 'shipping_name', with: address_attributes[:name]
      fill_in 'shipping_phone', with: address_attributes[:phone]
      find('a', text: '购买').click
      expect(page).to have_content('使用支付宝支付')
    end

    scenario 'I buy a free ticket' do
      visit event_path(event)
      within '.event-tickets' do
        select '1'
      end
      find('a', text: '购买').click
      expect(page).to have_content('您已经提交了订单，订单号为1，此订单为免费订单，不需要支付，谢谢。')
    end

    scenario 'I want to buy tickets, but sold out' do
      event.update_attribute :tickets_quantity, 0
      visit event_path(event)
      expect(page).to have_selector('.sold-out')
    end
  end

  context 'without user name and phone' do
    scenario 'I can create order' do
      visit event_path(event)
      within '.event-tickets' do
        select '1'
      end
      find('a', text: '购买').click
      within '.event-tickets' do
        fill_in 'user_name', with: '张三'
        fill_in 'user_phone', with: '13928452888'
      end
      find('a', text: '购买').click
      expect(page).to have_content('您已经提交了订单，订单号为1，此订单为免费订单，不需要支付，谢谢。')
    end
  end
end
