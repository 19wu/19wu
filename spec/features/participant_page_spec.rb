require File.expand_path('../../spec_helper', __FILE__)

feature 'participant page' do

  describe 'when create event user has signed in' do
    let(:event_creator) { login_user }
    let(:event) { FactoryGirl.create(:event, user: event_creator) }
    let(:user) { FactoryGirl.create(:user, login: 'jack') }
    let(:participant) { FactoryGirl.create(:event_participant, event_id: event.id, user_id: user.id) }

    before do
      event.stub(:participants).with(participant)
    end

    describe 'init show' do

      describe 'user information' do

        it "hasn't profile information" do
          visit event_participants_path(event)

          page.find("div#event_participant_#{participant.id} p.participant-login-name").should have_content(user.login)
          page.find("div#event_participant_#{participant.id} p.participant-name").should have_content("")
        end

        let(:has_profile_user) { FactoryGirl.create(:user, profile: create(:profile, name: 'jack')) }
        let(:has_profile_participant) { FactoryGirl.create(:event_participant, event_id: event.id, user_id: has_profile_user.id) }
        it "has profile information" do
          event.stub(:participants).with(has_profile_participant)

          visit event_participants_path(event)

          page.find("div#event_participant_#{has_profile_participant.id} p.participant-login-name").should have_content(has_profile_user.login)
          page.find("div#event_participant_#{has_profile_participant.id} p.participant-name").should have_content(has_profile_user.profile.name)
        end
      end

      it "the user hasn't checked in this event" do
        visit event_participants_path(event)

        page.should have_selector("button#check-in-event-participant-#{participant.id}")
        expect(page).to have_content I18n.t('labels.check_in_button')
      end

      let(:has_checked_in_user) { FactoryGirl.create(:user) }
      let(:haschecked_in_participant) { FactoryGirl.create(:event_participant, event_id: event.id, user_id: has_checked_in_user.id, joined: true) }
      it 'the user has checked in this event' do
        event.stub(:participants).with(haschecked_in_participant)

        visit event_participants_path(event)

        expect(page).to have_content I18n.t('labels.has_checked_in_button')
        page.find("button#check-in-event-participant-#{haschecked_in_participant.id}")['disabled'].should == "disabled"
      end
    end

    it 'click check_in button will be seccses' do
      visit event_participants_path(event)

      click_button "check-in-event-participant-#{participant.id}"

      current_path.should == event_participants_path(event)
      expect(page).to have_content I18n.t('labels.has_checked_in_button')
    end
  end

  describe "when create event user hasn't signed in" do
    let(:event) { FactoryGirl.create(:event) }

    it 'will redirect to login view' do
        visit event_participants_path(event)

        current_path.should == new_user_session_path
    end
  end

end
