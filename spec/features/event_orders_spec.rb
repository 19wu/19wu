# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'event orders', js: true do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:ticket) { event.tickets.first }
  given(:address_attributes) { attributes_for(:shipping_address) }

  before do
    event.update_attribute :tickets_quantity, 20
    Timecop.travel(Date.parse('2013-08-25'))
  end

  after { Timecop.return }

  context 'as login customer' do
    before { sign_in user }
    context 'with user name and phone' do
      before { user.profile.update_attribute :name, 'saberma' }
      scenario 'I can create order' do
        ticket.update_attribute :price, 299
        visit event_path(event)
        within '.event-tickets' do
          select '1'
        end
        find('a', text: '购买').click
        expect(page).to have_content('您已经提交了订单，订单号为 201308250001，请尽快支付')
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
        expect(page).to have_content('您已经提交了订单，订单号为 201308250001，此订单为免费订单，不需要支付，谢谢。')
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
        expect(page).to have_content('您已经提交了订单，订单号为 201308250001，此订单为免费订单，不需要支付，谢谢。')
      end
    end
  end

  context 'as guest customer' do
    scenario 'I can register and order in place' do
      visit event_path(event)
      within('.event-tickets') { select '1' }
      find('a', text: '购买').click
      within '.signup' do
        fill_in 'user_login', with: 'someone'
        fill_in 'user_email', with: 'someone@example.com'
        fill_in 'user_password', with: '666666'
        find('a', text: '注册').click
      end
      within '.event-tickets' do
        fill_in 'user_name', with: '张三'
        fill_in 'user_phone', with: '13928452888'
      end
      find('a', text: '购买').click
      expect(page).to have_content('您已经提交了订单，订单号为 201308250001，此订单为免费订单，不需要支付，谢谢。')
    end
    scenario 'I can login and order in place' do
      visit event_path(event)
      within('.event-tickets') { select '1' }
      find('a', text: '购买').click
      within '.signup' do
        find('a', text: '登录').click
      end
      within '.login' do
        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        find('a', text: '登录').click
      end
      find('a', text: '购买').click
      within '.event-tickets' do
        fill_in 'user_name', with: '张三'
        fill_in 'user_phone', with: '13928452888'
      end
      find('a', text: '购买').click
      expect(page).to have_content('您已经提交了订单，订单号为 201308250001，此订单为免费订单，不需要支付，谢谢。')
    end
  end

  context 'as organizer' do
    given(:order) { create(:order_with_items, event: event, quantity: 2) }
    given(:trade_no) { '2013080841700373' }
    before do
      order.pay(trade_no)
      sign_in user
    end
    scenario 'I can search order' do
      visit filter_event_orders_path(event, status: :paid)
      within '.form-search' do
        select order.items.first.name
        fill_in 'q[items_unit_price_in_cents_gteq_price]', with: '300'
        click_on '查询'
      end
      expect(page).not_to have_content(order.number)
      within '.form-search' do
        select order.items.first.name
        fill_in 'q[items_unit_price_in_cents_gteq_price]', with: '299'
        click_on '查询'
      end
      expect(page).to have_content(order.number)
      expect(page).to have_content("公司票（299元） x 2") # 票种
    end
  end
end
