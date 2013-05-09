require File.expand_path('../../spec_helper', __FILE__)

feature 'event page' do
  given(:content) {
    <<-MD
# title #

-   list
    MD
  }

  given(:event) { FactoryGirl.create(:event, :content => content, :user => login_user) }

  scenario 'I see the markdown formatted event content' do
    visit event_path(event)

    page.should have_selector('.event-body h1', :text => 'title')
    page.should have_selector('.event-body li', :text => 'list')
  end

  scenario 'I see list of participants', js: true do
    users = create_list(:user, 5)
    event.participated_users << users

    visit event_path(event)
    page.should have_selector('.event-participants img.gravatar', :count => 5)
  end

  describe 'when user has signed in', js: true do
    let(:event) { FactoryGirl.create(:event, :user => FactoryGirl.create(:user)) }
    before do
      sign_in
      Event.stub(:find).with(event.id.to_s).and_return(event)
    end

    describe 'init show' do
      it "hasn't join this event" do
        visit event_path(event)
        page.should have_selector('a', text: I18n.t('views.join.state')[false])
      end

      it 'has join this event' do
        event.stub(:has?).and_return(true)
        visit event_path(event)
        page.should have_selector('a', text: I18n.t('views.join.state')[true])
      end
    end

    it 'click join_event button will be seccses' do
      visit event_path(event)
      # click_link '我要参加' # a with ng-href attribute will raise: Capybara::ElementNotFound: Unable to find link "我要参加"
      find('a', text: I18n.t('views.join.state')[false]).click
      current_path.should == event_path(event)
      expect(page).to have_content I18n.t('views.join.state')[true]
    end
  end

  describe 'when user has not signed in', js: true do
    let(:event) { FactoryGirl.create(:event, :user => FactoryGirl.create(:user)) }
    before do
      Event.stub(:find).with(event.id.to_s).and_return(event)
    end

    it 'init show' do
      visit event_path(event)
      page.should have_selector('a', text: I18n.t('views.join.state')[false])
    end

    it 'click join_event button will be redirect to user login view' do
      visit event_path(event)
      find('a', text: I18n.t('views.join.state')[false]).click
      current_path.should == new_user_session_path
    end
  end

end
