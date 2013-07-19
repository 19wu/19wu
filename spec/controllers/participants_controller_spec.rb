require 'spec_helper'

describe ParticipantsController do

  describe "GET 'index'" do
    let(:user) { login_user }
    let(:event) { create(:event, user: user) }

    it "renders the participant list" do
      get :index, :event_id => event.id
      response.should render_template('index')
    end

    context 'sort by user login field' do
      %w{jack lucy dave lily john beth}.each do |name|
        let(name) { create(:user, login: name) }
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

  describe "PATCH 'update'" do
    let(:event) { create(:event) }
    let(:event_creator) { event.user }
    let(:user) { create(:user) }
    let(:participant) { create(:event_participant, event_id: event.id, user_id: user.id) }
    before { event_creator.confirm! }
    context 'when user has signed in' do
      before { login_user(event_creator) }
      it 'with check in event' do
        patch :update, event_id: event.id, id: participant.id
        participant.reload.joined.should be_true
        response.should redirect_to(event_participants_path(event))
      end
    end

    context 'when user has not yet signed in' do
      it 'should be redirect to user login view' do
        patch :update, event_id: event.id, id: participant.id
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  context "when user do not create the event" do
    let(:event) { create(:event) }
    let(:user) { create(:user) }
    before { user.confirm! }
    before { login_user(user) }
    describe 'should not allow to' do
      describe "GET 'index'" do
        it 'should be redirect to user login view' do
          get :index, :event_id => event.id
          response.should render_template('application/403')
        end
      end
      describe "PATCH 'update'" do
        let(:participant) { create(:event_participant, event_id: event.id, user_id: user.id) }
        it 'should be redirect to user login view' do
          patch :update, event_id: event.id, id: participant.id
          response.should render_template('application/403')
        end
      end
    end
  end

end
