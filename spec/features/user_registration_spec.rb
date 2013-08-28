# -*- encoding : utf-8 -*-
require 'spec_helper'

feature 'user registration' do
  let(:user) { build :user }
  let(:admin) { create :user, :admin, :confirmed }

  scenario 'through home' do
    visit '/'
    # sign up
    fill_in 'user_login', with: user.login
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button I18n.t('labels.sign_up')
    expect(page).to have_content(I18n.t('devise.registrations.signed_up'))

    open_email(user.email)
    current_email.click_link '激活帐号'
    expect(page).to have_content(I18n.t('devise.confirmations.confirmed'))
    open_email(user.email)
    expect(current_email.subject).to have_content(I18n.t('email.welcome.subject'))

    # can not create event, need to upgrade
    click_link I18n.t('labels.launch_event')
    expect(page).to have_content(I18n.t('labels.need_upgrade_invitation'))
    fill_in 'user_invite_reason', with: 'blah blah'
    click_button I18n.t('labels.apply_sign_up')
    sign_out

    # admin invite
    admin_invite

    # email notify
    open_email(user.email)
    expect(current_email.subject).to have_content(I18n.t('email.invited.subject', login: user.login))
    expect(current_email).to have_content user.login

    # login in
    visit '/users/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button I18n.t('labels.sign_in')

    # can create event
    can_create_event
  end

  scenario 'directly' do
    visit '/users/sign_up'
    # sign up
    fill_in 'user_login', with: user.login
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button I18n.t('labels.sign_up')
    expect(page).to have_content(I18n.t('devise.registrations.signed_up'))

    open_email(user.email)
    current_email.click_link '激活帐号'
    expect(page).to have_content(I18n.t('devise.confirmations.confirmed'))
    open_email(user.email)
    expect(current_email.subject).to have_content(I18n.t('email.welcome.subject'))

    # can not create event, need to upgrade
    click_link I18n.t('labels.launch_event')
    expect(page).to have_content(I18n.t('labels.need_upgrade_invitation'))
    fill_in 'user_invite_reason', with: 'blah blah'
    click_button I18n.t('labels.apply_sign_up')
    sign_out

    # admin invite
    admin_invite

    # email notify
    open_email(user.email)
    expect(current_email.subject).to have_content(I18n.t('email.invited.subject', login: user.login))
    expect(current_email).to have_content user.login

    # login in
    visit '/users/sign_in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button I18n.t('labels.sign_in')

    # can create event
    can_create_event
  end

  private
  def admin_invite
    click_link I18n.t('labels.sign_in')
    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: admin.password
    click_button I18n.t('labels.sign_in')
    click_link I18n.t('labels.invitations')
    within 'table' do
      click_link I18n.t('labels.invite_button')
    end
    sign_out
  end

  def sign_out
    click_link I18n.t('devise.navigation.sign_out')
  end

  def can_create_event
    click_link I18n.t('labels.launch_event')
    expect(page).to have_content(I18n.t('activerecord.attributes.event.title'))
  end
end
