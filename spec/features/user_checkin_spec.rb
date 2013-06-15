require 'spec_helper'

feature "user check in" do
  given(:lilei) { create(:user, :confirmed) }
  given(:hanmeimei) { create(:user, :confirmed) }
  given(:event) { create(:event, user: lilei, start_time: 0.day.since) }
  given(:participant) { create(:event_participant, event: event, user: hanmeimei) }

  context 'event is start today' do
    context 'user has joined' do
      before do
        participant
        login_user hanmeimei
      end
      scenario "checkin with valid checkin code", js: true do
        visit event_path(event)
        fill_in 'appendedInputButton', with: event.checkin_code
        click_on I18n.t('labels.check_in_button')
        expect(page).to have_content I18n.t('flash.participants.checkin_welcome')
      end
      scenario "checkin with invalid checkin code", js: true do
        visit event_path(event)
        fill_in 'appendedInputButton', with: event.checkin_code + "invalid"
        click_on I18n.t('labels.check_in_button')
        expect(page).to have_content I18n.t('flash.participants.checkin_wrong_checkin_code')
      end
      scenario "checkin twice" do
        visit checkin_event_path(event, checkin_code: event.checkin_code)
        visit checkin_event_path(event, checkin_code: event.checkin_code)
        expect(page).to have_content I18n.t('flash.participants.checkin_more_than_1_time')
      end
    end
    context 'user has not joined' do
      scenario "checkin" do
        login_user hanmeimei
        visit checkin_event_path(event, checkin_code: event.checkin_code)
        expect(page).to have_content I18n.t('flash.participants.checkin_need_join_first')
      end
    end
  end

  context 'event start tomorrow' do
    given(:event) { create(:event, user: lilei, start_time: 1.day.since) }
    scenario "checkin" do
      participant
      login_user hanmeimei
      visit checkin_event_path(event, checkin_code: event.checkin_code)
      expect(page).to have_content I18n.t('flash.participants.checkin_in_need_the_same_day_of_event_starttime')
    end
  end
end
