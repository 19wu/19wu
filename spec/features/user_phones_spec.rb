# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'user phones' do
  given(:user) { create(:user, :confirmed, phone: nil) }
  given(:code) { '1234' }
  before do
    sign_in user
    Rails.cache.clear
  end
  scenario 'I can save phone', js: true do
    click_on I18n.t('flash.user_phones.here')
    fill_in 'phone', with: '13928452888'
    click_on I18n.t('buttons.user_phone.get_code')
    fill_in 'code', with: code
    click_on I18n.t('helpers.submit.user.update')
    page.should have_content(I18n.t('flash.user_phones.updated'))
    page.should_not have_content(I18n.t('flash.user_phones.here'))
  end
end
