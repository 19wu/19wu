require File.expand_path('../../spec_helper', __FILE__)

feature 'follower page' do
  describe 'create event with participant info' do   
    let(:event) { create(:event, :user => create(:user)) }
    let(:participant) { login_user }
    subject { event.group }

    before do
      Event.stub(:find).with(event.id.to_s).and_return(event)
      participant.follow(subject) 
    end

    describe 'init show' do
      it "has user information" do
        visit event_path(event)+'/followers'
        page.should have_selector('a', text: event.title)
        page.find("li#group_event_#{participant.id} span.follower-login-name").should have_content(participant.login)
      end
    end

  end
end
