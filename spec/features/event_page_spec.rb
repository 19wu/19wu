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
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, user: user) }
    let(:old_event) { create(:event, slug: "rubyconfchina2", start_time: 3.day.ago, end_time: nil, user: user) }
    before do
      sign_in user
      Event.stub(:find).with(event.id.to_s).and_return(event)
      Event.stub(:find).with(old_event.id.to_s).and_return(old_event) 
    end

    describe 'init show' do
      it "event display end if start_time < Time.now" do 
        visit event_path(old_event)
        page.should have_selector('a', text: I18n.t('views.join.state')['event_end'])
      end 

      it "hasn't join this event" do
        visit event_path(event)
        page.should have_selector('a', text: I18n.t('views.join.state')[false])
      end

      it 'has join this event' do
        event.stub(:has?).and_return(true)
        event.participants.stub(:find_by_user_id).and_return(create(:event_participant))
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
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, user: user) }
    let(:old_event) { create(:event, slug: "rubyconfchina2", start_time: 3.day.ago, end_time: nil, user: user) }
    before do
      Event.stub(:find).with(event.id.to_s).and_return(event)
      Event.stub(:find).with(old_event.id.to_s).and_return(old_event)
    end

    it "event display end if start_time < Time.now" do 
      visit event_path(old_event)
      page.should have_selector('a', text: I18n.t('views.join.state')['event_end'])
    end 

    it 'init show' do
      visit event_path(event)
      page.should have_selector('a', text: I18n.t('views.join.state')[false])
    end

    it 'click join_event button will be redirect to user login view' do
      visit event_path(event)
      find('a', text: I18n.t('views.join.state')[false]).click
      current_path.should == new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button I18n.t('labels.sign_in')
      page.should have_content(event.title) # issue#339
    end
  end

end
