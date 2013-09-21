# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'orders refunds', js: true do
  given(:support) { create(:user, :confirmed, :admin) }
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:order) { create(:order_with_items, event: event) }
  given(:trade_no) { '2013080841700373' }

  before { order.pay(trade_no) }

  context 'as organizer' do
    before { sign_in user }
    scenario 'I can submit order refund' do
      visit filter_event_orders_path(event, status: :paid)
      within '.orders-list' do
        click_on '退款'
        fill_in '退款金额', with: '100'
        fill_in '退款原因', with: '测试'
        click_on '提交'
      end
      expect(page).to have_content("即将向 #{order.user.login} 退款 100 元（原因：测试）")

      open_email(Settings.raw_email(Settings.email.from))
      expect(current_email).to have_content('活动主办方刚刚申请退款')
      expect(current_email.subject).to have_content(I18n.t('email.order.support.refund.subject', title: event.title, number: order.number))
    end
  end

  context 'as support' do
    given!(:refund) { create :event_order_refund, :submited, order: order }
    before { sign_in support }
    scenario 'I can generate refund link' do
      visit refunds_path
      click_on '获取退款链接'
      within '.actions' do
        expect(page).to have_content('退款')
      end
    end
  end
end
