# -*- encoding : utf-8 -*-
require 'spec_helper'

feature 'user registration' do
  let(:user) { build :user }
  let(:submit) { I18n.t('labels.sign_up') }

  before(:each) { visit '/' }

  scenario 'successfully' do
    fill_in 'user_login', with: user.login
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button submit
    expect(page).to have_content(I18n.t('devise.registrations.signed_up_but_unconfirmed'))

    open_email(user.email)
    current_email.click_link '激活帐号'
    expect(page).to have_content(I18n.t('devise.confirmations.confirmed'))
    open_email(user.email)
    expect(current_email.subject).to have_content(I18n.t('email.welcome.subject'))
  end
end
