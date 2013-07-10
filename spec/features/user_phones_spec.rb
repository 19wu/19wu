# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'user phones' do
  given(:user) { create(:user, :confirmed) }
  given(:code) { '1234' }
  before { sign_in user }
  scenario 'I can save phone', js: true do
    visit edit_user_phone_path
    fill_in 'phone', with: '13928452888'
    click_on I18n.t('buttons.user_phone.get_code')
    fill_in 'code', with: code
    click_on I18n.t('helpers.submit.user.update')
    page.should have_content(I18n.t('flash.user_phones.updated'))
  end
end
