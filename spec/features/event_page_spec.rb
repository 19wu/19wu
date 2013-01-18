require File.expand_path('../../spec_helper', __FILE__)

feature 'event page' do
  given(:content) {
    <<-MD
# title #

-   list
    MD
  }

  given(:event) { create :event, :content => content }

  scenario 'I see the markdown formatted event content' do
    visit event_path(event)

    page.should have_selector('.event-body h1', :text => 'title')
    page.should have_selector('.event-body li', :text => 'list')
  end

  describe 'when user has signed in' do
    let(:event) { FactoryGirl.create(:event) }
    before do
      sign_in
      Event.stub(:find).with(event.id.to_s).and_return(event)
    end

    describe 'init show' do
      it "hasn't join this event" do
        visit event_path(event)
        page.should have_selector('button#join_event')
        expect(page).to have_content I18n.t('labels.join_event_button')
      end

      it 'has join this event' do
        event.stub(:has?).and_return(true)
        visit event_path(event)
        expect(page).to have_content I18n.t('labels.has_joined_event_button')
        page.find('button#join_event')['disabled'].should == "disabled"
      end
    end

    it 'click join_event button will be seccses' do
      visit event_path(event)
      click_button 'join_event'
      current_path.should == event_path(event)
      expect(page).to have_content I18n.t('labels.has_joined_event_button')
    end
  end

  describe 'when user has signed in' do
    before do
      Event.stub(:find).with(event.id.to_s).and_return(event)
    end

    it 'init show' do
        visit event_path(event)
        page.should have_selector('button#join_event')
        expect(page).to have_content I18n.t('labels.join_event_button')
    end

    it 'click join_event button will be seccses' do
      visit event_path(event)
      click_button 'join_event'
      current_path.should == new_user_session_path
    end
  end

end
