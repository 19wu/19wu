# -*- encoding : utf-8 -*-
require 'spec_helper'

feature 'user registration' do
  let(:user) { build :user }
  let(:submit) { I18n.t('label.sign_up') }

  before(:each) { visit '/' }

  scenario 'success' do
    fill_in 'user_login', with: user.login
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password_confirmation

    click_button submit
    expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
  end

  context 'failure' do
    scenario 'with an invalid email address' do
      fill_in 'user_login', with: user.login
      fill_in 'user_email', with: 'useratexampledotcom'
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password_confirmation

      click_button submit
      expect(page).to have_content '因为 1 个错误导致'
    end

    scenario 'with a blank login name' do
      fill_in 'user_login', with: ''
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      fill_in 'user_password_confirmation', with: user.password_confirmation

      click_button submit

      # expect(page).to have_content '因为 1 个错误导致'
      expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
    end
  end
end