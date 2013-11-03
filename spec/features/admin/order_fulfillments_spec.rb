# encoding: utf-8
require File.expand_path('../../../spec_helper', __FILE__)

feature 'orders fulfillments', js: true do
  given(:support) { create(:user, :confirmed, :admin) }
  given!(:order) { create(:order_with_items, require_invoice: true, paid: true) }
  given(:tracking_number) { '112521197075' }

  before { sign_in support }

  scenario 'I can save fulfillment tracking number' do
    visit admin_fulfillments_path
    fill_in '顺丰快递单号', with: tracking_number
    click_on '提交'
    expect(page).to have_content("抬头：#{order.shipping_address.invoice_title}")
    expect(page).to have_content("金额：#{order.paid_amount.to_i}")
    expect(page).to have_content("顺丰快递单号：#{tracking_number}")
  end
end
