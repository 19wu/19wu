# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'event orders', js: true do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:ticket) { create(:ticket, event: event) }
  before do
    ticket
    sign_in user
  end
  scenario 'I can create order' do
    visit event_path(event)
    within '.event-tickets' do
      select '1'
    end
    find('a', text: '报名').click
    expect(page).to have_content('您已经提交了订单，订单号为1，请尽快支付')
    expect(page).to have_content('使用支付宝支付')
  end
end
