module FeatureMacros # http://bit.ly/QrzOH8
  def sign_in
    user = create(:user)
    user.confirm!
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button I18n.t('label.sign_in')
  end
end
