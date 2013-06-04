require 'spec_helper'

feature "user check in", js: true do
  background do
    @lilei = create(:user, :confirmed)
    @hanmeimei = create(:user, :confirmed)
  end

  scenario "checkin with valid checkin code" do
    @event = create(:event, user: @lilei, start_time: 0.day.since)
    @participant = create(:event_participant, event: @event, user: @hanmeimei)
    login_user @hanmeimei

    visit event_path(@event)
    expect(page).to have_content I18n.t('labels.check_in_button')
    
    fill_in 'appendedInputButton', with: @event.checkin_code
    click_on I18n.t('labels.check_in_button')

    expect(page).to have_content I18n.t('flash.participants.checkin_welcome')
  end

  scenario "checkin with invalid checkin code" do
    @event = create(:event, user: @lilei, start_time: 0.day.since)
    @participant = create(:event_participant, event: @event, user: @hanmeimei)
    login_user @hanmeimei

    visit event_path(@event)
    expect(page).to have_content I18n.t('labels.check_in_button')
    
    fill_in 'appendedInputButton', with: @event.checkin_code + "invalid"
    click_on I18n.t('labels.check_in_button')

    expect(page).to have_content I18n.t('flash.participants.checkin_wrong_checkin_code')
  end

  scenario "checkin 1 day before event start" do
    @event = create(:event, user: @lilei, start_time: 1.day.since)
    @participant = create(:event_participant, event: @event, user: @hanmeimei)
    login_user @hanmeimei

    visit checkin_event_path(@event, checkin_code: @event.checkin_code)
    expect(page).to have_content I18n.t('flash.participants.checkin_in_need_the_same_day_of_event_starttime')
  end

  scenario "checkin without join event" do
    @event = create(:event, user: @lilei, start_time: 0.day.since)
    login_user @hanmeimei

    visit checkin_event_path(@event, checkin_code: @event.checkin_code)
    expect(page).to have_content I18n.t('flash.participants.checkin_need_join_first')
  end

  scenario "checkin twice" do
    @event = create(:event, user: @lilei, start_time: 0.day.since)
    @participant = create(:event_participant, event: @event, user: @hanmeimei)
    login_user @hanmeimei

    visit checkin_event_path(@event, checkin_code: @event.checkin_code)
    visit checkin_event_path(@event, checkin_code: @event.checkin_code)
    expect(page).to have_content I18n.t('flash.participants.checkin_more_than_1_time')
  end
end