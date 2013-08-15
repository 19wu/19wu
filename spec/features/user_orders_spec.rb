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

      expect(page).to have_content(I18n.t('views.my_orders.pay'))
      expect(page).to have_content(I18n.t('views.my_orders.cancel'))
    end

    scenario 'I can cancel order' do
      visit user_orders_path

      find('a', text: I18n.t('views.my_orders.cancel')).click

      expect(page).to have_content(I18n.t('views.my_orders.pay_status.canceled'))
    end
  end

  context 'has paid' do
    before { order.pay!('2013080841700373') }

    scenario 'I can see refund link' do
      visit user_orders_path

      expect(page).to have_content(I18n.t('views.my_orders.refund'))
    end

    scenario 'I can refund order' do
      visit user_orders_path

      find('a', text: I18n.t('views.my_orders.refund')).click

      expect(page).to have_content(I18n.t('views.my_orders.pay_status.refunding'))
    end
  end
end
