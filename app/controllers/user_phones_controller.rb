class UserPhonesController < ApplicationController
  before_filter :authenticate_user!
  layout 'settings'

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.phone = params[:phone]
    if @user.phone.present? && params[:code].to_i == cookies.signed[:code] && @user.save
      cookies.delete(:code)
      redirect_to user_path(@user), notice: I18n.t('flash.user_phones.updated')
    else
      render :edit
    end
  end

  def send_code
    code = cookies.signed[:code] || rand(1000..9999)
    Rails.logger.info I18n.t('sms.user.phone_code', code: code)
    ChinaSMS.to params[:phone], I18n.t('sms.user.phone_code', code: code)
    cookies.signed[:code] = { value: code, expires: 1.hour.from_now }
    render nothing: true
  end
end
