# -*- encoding : utf-8 -*-
require 'spec_helper'

feature 'user registration' do
  let(:user) { build :user }
  let(:admin) { create :user, :admin, :confirmed }
  let(:submit) { I18n.t('labels.apply_sign_up') }

  before(:each) { visit '/' }

  scenario 'successfully' do
    # apply sign up
    fill_in 'user_email', with: user.email
    fill_in 'user_invite_reason', with: '测试'
    click_button submit
    expect(page).to have_content(I18n.t('devise.invitations.received'))

    # admin invite
    click_link I18n.t('labels.sign_in')
    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: admin.password
    click_button I18n.t('labels.sign_in')
    click_link I18n.t('labels.invitations')
    within 'table' do
      click_link I18n.t('labels.invite_button')
    end
    click_link I18n.t('devise.navigation.sign_out')

    # accept
    open_email(user.email)
    current_email.click_link '接受邀请'
    fill_in 'user_login', with: user.login
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    click_button I18n.t('devise.invitations.edit.submit_button')
    expect(page).to have_content(I18n.t('devise.invitations.updated'))
  end
end
