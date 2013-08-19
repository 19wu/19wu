# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'user orders', js: true do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:order) { create(:order_with_items, items_count: 2, event: event, user: user) }

  before do
    sign_in user
  end

  context 'pending to pay' do
    before { order }

    scenario 'I can see pay link and cancel link' do
      visit user_orders_path

      expect(page).to have_content("#{I18n.t('views.my_orders.pay')} |")
      expect(page).to have_content("| #{I18n.t('views.my_orders.cancel')}")
    end

    scenario 'I can not see pay link and cancel link when event finished' do
      event.update! start_time: 7.days.ago, end_time: 6.days.ago

      visit user_orders_path

      expect(page).to have_no_content("#{I18n.t('views.my_orders.pay')} |")
      expect(page).to have_no_content("| #{I18n.t('views.my_orders.cancel')}")
    end

    scenario 'I can cancel order' do
      visit user_orders_path

      stub_confirm
      find('a', text: I18n.t('views.my_orders.cancel')).click

      expect(page).to have_content(I18n.t('views.my_orders.pay_status.canceled'))
    end
  end

  context 'has paid' do
    before { order.pay!('2013080841700373') }

    scenario 'I can refund at least 7 days before event starts' do
      event.update! start_time: 8.days.since, end_time: 9.days.since

      visit user_orders_path
      expect(page).to have_content(I18n.t('views.my_orders.request_refund'))

      stub_confirm
      find('a', text: I18n.t('views.my_orders.request_refund')).click
      expect(page).to have_content(I18n.t('views.my_orders.pay_status.request_refund'))
    end

    scenario 'I can not refund order when event draws near' do
      visit user_orders_path

      expect(page).to have_no_content(I18n.t('views.my_orders.request_refund'))
    end
  end
end
