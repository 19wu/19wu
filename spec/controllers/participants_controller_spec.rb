require 'spec_helper'

describe ParticipantsController do

  describe "GET 'index'" do

    let(:event) { FactoryGirl.create(:event) }
    login_user

    it "renders the participant list" do
      get :index, :event_id => event.id
      response.should render_template('index')
    end

    context 'sort by user login field' do
      %w{jack lucy dave lily john beth}.each do |name|
        let(name) { FactoryGirl.create(:user, login: name) }
      end

      before do
        [jack, lucy, dave, lily, john, beth].each do |user|
          event.participants.create(:user_id => user.id)
        end
      end

      it 'as asc' do
        get :index, :event_id => event.id

        participants = assigns[:participants]

        participants.count.should ==  6
        %w{jack lucy dave lily john beth}.sort.each_with_index do |name, index|
          participants[index].user.login.should == name
        end
      end
    end
  end

  describe "PUT 'update'" do
    let(:event) { FactoryGirl.create(:event) }
    let(:participant) { FactoryGirl.create(:event_participant) }
    context 'when user has signed in' do
      login_user
      it 'with check in event' do
        participant.stub(:joined => true)
        put :update, event_id: event.id, id: participant.id

        participant.joined.should be_true
        response.should redirect_to(event_participants_path(event))
      end
    end

    context 'when user has not yet signed in' do
      it 'should be redirect to user login view' do
        put :update, event_id: event.id, id: participant.id
        response.should redirect_to(new_user_session_path)
      end
    end
  end

end
