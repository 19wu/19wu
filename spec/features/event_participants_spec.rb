# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'event participants', js: true do
  given(:user) { create(:user, :confirmed) }
  given(:event) { create(:event, user: user) }
  given(:order) { create(:order_with_items, event: event) }
  given(:participant) { order.participant }
  given(:trade_no) { '2013080841700373' }
  before do
    sign_in user
    visit checkin_event_participants_path(event)
  end

  context 'with participant' do
    before { order.pay! trade_no }
    context 'with checkin code' do
      scenario 'I can help user to check in' do
        within '.checkin-form' do
          fill_in 'code', with: participant.checkin_code
          click_on '签到'
        end
        page.should have_content("#{participant.checkin_code} 签到成功，门票总数：1 张")
      end
    end

    context 'with used code' do
      before { participant.checkin! }
      scenario 'I can see the error' do
        within '.checkin-form' do
          fill_in 'code', with: participant.checkin_code
          click_on '签到'
        end
        page.should have_content("签到码 已于 #{participant.checkin_at.to_s(:db)} 使用，请勿重复签到。")
      end
    end
  end

  context 'with invalid code' do
    scenario 'I can see the error' do
      within '.checkin-form' do
        fill_in 'code', with: 'invalid code'
        click_on '签到'
      end
      page.should have_content("签到码不正确。")
    end
  end
end
