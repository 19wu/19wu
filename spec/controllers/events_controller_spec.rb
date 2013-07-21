require 'spec_helper'

describe EventsController do

  describe "GET 'index'" do
    login_user
    it "renders the event list" do
      get 'index'
      response.should render_template('index')
    end
  end

  describe "GET 'joined'" do
    login_user
    it "renders the event list" do
      get 'joined'
      response.should render_template('joined')
    end
  end

  describe "GET 'new'" do
    context 'when user has signed in' do
      let(:user) { login_user }
      before { login_user }
      it "builds a new event" do
        get 'new'
        assigns[:event].should be_a_kind_of(Event)
        assigns[:event].should be_a_new_record
      end
      it "renders the new event form" do
        get 'new'
        response.should render_template('new')
      end
      context 'with other event' do
        let(:event) { create(:event, user: user) }
        before { event }
        it "should show source events" do
          get 'new'
          assigns[:source_events].should_not be_empty
        end
        it "should be copy" do
          get 'new', from: event.id
          assigns[:event].should be_a_new_record
          assigns[:event].title.should eql event.title
        end
      end
    end
    context 'when user has not yet signed in' do
      it "should be redirect" do
        get 'new'
        response.should be_redirect
      end
    end
  end

  describe "POST 'create'" do
    context 'when user has signed in' do
      login_user
      let(:valid_attributes) { attributes_for(:event) }
      context 'with valid attributes' do
        it 'creates the event' do
          expect {
            post 'create', :event => valid_attributes
          }.to change{Event.count}.by(1)
        end
      end
      context 'with invalid attributes' do # issue#392
        render_views
        it 'should not creates the event' do
          expect {
            post 'create', :event => valid_attributes.except(:start_time)
          }.to_not change{Event.count}
          response.should be_success
        end
      end

      context 'post with compound_start_time_attributes' do
        let(:compound_start_time_attributes) do
          {
            'date' => '2013-12-31',
            'time' => '12:10:30 PM'
          }
        end
        let(:attributes) do
          valid_attributes.except('start_time').
            merge('compound_start_time_attributes' => compound_start_time_attributes)
        end

        it 'creates event with date 2013-12-31 12:10:30' do
          post 'create', :event => attributes
          assigns[:event].start_time.should == Time.zone.parse('2013-12-31 12:10:30')
        end
      end
    end
    context 'when user has not yet signed in' do
      it "should be redirect" do
        post 'create'
        response.should be_redirect
      end
    end
  end

  describe "PATCH 'update'" do
    let(:event_creator) { login_user }
    let(:event) { FactoryGirl.create(:event, user: event_creator) }
    let(:valid_attributes) { attributes_for(:event) }
    context 'when user has signed in' do
      context 'with valid attributes' do
        it 'update the event' do
          patch 'update', :id => event.id, :event => valid_attributes
          response.should redirect_to(edit_event_path(event))
        end
      end

      context 'update all attributes' do
        let(:compound_start_time_attributes) do
          {
            'date' => '2013-01-08',
            'time' => '4:10:30 PM'
          }
        end
        let(:compound_end_time_attributes) do
          {
            'date' => '2013-01-08',
            'time' => '6:10:30 PM'
          }
        end
        let(:attributes) do
          valid_attributes.merge(
                'title' => "19wu development meeting by issuse #185",
                'location' => "Dalian, China",
                'content' => "Dalian 19wu development meeting by issuse #185",
                'location_guide' => "Best by Plant come here",
                'compound_start_time_attributes' => compound_start_time_attributes,
                'compound_end_time_attributes' => compound_end_time_attributes
            )
        end

        it 'when all input changed' do
          patch 'update', :id => event.id, :event => attributes
          assigns[:event].title.should == "19wu development meeting by issuse #185"
          assigns[:event].location.should ==  "Dalian, China"
          assigns[:event].content.should == "Dalian 19wu development meeting by issuse #185"
          assigns[:event].location_guide.should == "Best by Plant come here"
          assigns[:event].start_time.should == Time.zone.parse('2013-01-08 16:10:30')
          assigns[:event].end_time.should == Time.zone.parse('2013-01-08 18:10:30')
        end
      end
    end

    context 'when user has not yet signed in' do
      it "should be redirect" do
        patch 'update', :id => event.id, :event => valid_attributes
        response.should be_redirect
      end
    end
  end

  describe "POST 'join'" do
    let(:event) { FactoryGirl.create(:event, :user => FactoryGirl.create(:user)) }
    context 'when user has signed in' do
      let(:user) { login_user }
      before { user }
      it 'with join a event' do
        expect {
          post 'join', id: event.id
        }.to change{event.participants.count}.by(1)
        user.following?(event.group).should be_true
        response.should be_success
      end
      context 'and has already joined' do
        before { event.participants.create(user_id: user.id) }
        it 'should do nothing' do
          expect do
            post 'join', id: event.id
          end.not_to change{event.participants.count}
        end
      end
    end
    context 'when user has not yet signed in' do
      it 'should be redirect to user login view' do
        post 'join', id: event.id
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  describe "participant" do
    let(:event) { create(:event, :user => create(:user)) }
    let(:participant) { login_user }
    subject { event.group }
    context 'follow' do
      before { participant }
      before { post :follow, id: event.id }
      its('followers.first') { should eql participant }
    end
    context 'unfollow' do
      before { participant.follow(subject) }
      before { post :unfollow, id: event.id }
      its(:followers) { should be_empty }
    end
  end

  describe "GET checkin" do
    context "event.start_time.today? == true" do
      context "user has joined this event" do
        context "with valid checkin code" do
          it "should alert user if user already checked in" do
            event = create(:event, start_time: Time.now)
            user  = create(:user, :confirmed)
            participant = create(:event_participant, event: event, user: user)
            participant.joined = true
            participant.save
            login_user user

            get :checkin, id: event.id, checkin_code: event.checkin_code
            expect(flash[:alert]).to eq(I18n.t('flash.participants.checkin_more_than_1_time'))
          end

          it "should checkin user"  do
            event = create(:event, start_time: Time.now)
            user  = create(:user, :confirmed)
            participant = create(:event_participant, event: event, user: user)
            login_user user

            get :checkin, id: event.id, checkin_code: event.checkin_code
            expect(participant.reload.joined).to be_true
          end

          it "should redirect to event page" do
            event = create(:event, start_time: Time.now)
            user  = create(:user, :confirmed)
            participant = create(:event_participant, event: event, user: user)
            login_user user

            get :checkin, id: event.id, checkin_code: event.checkin_code
            expect(response).to redirect_to event_path(event)
          end

          it "should set welcome message" do
            event = create(:event, start_time: Time.now)
            user  = create(:user, :confirmed)
            participant = create(:event_participant, event: event, user: user)
            login_user user

            get :checkin, id: event.id, checkin_code: event.checkin_code
            expect(flash[:notice]).to eq(I18n.t('flash.participants.checkin_welcome'))
          end
        end

        context "with invalid checkin code" do
          it "should redirect to event page" do
            event = create(:event, start_time: Time.now)
            user  = create(:user, :confirmed)
            participant = create(:event_participant, event: event, user: user)
            login_user user

            get :checkin, id: event.id, checkin_code: event.checkin_code + "not_valid"
            expect(response).to redirect_to event_path(event)
          end

          it "should set error message" do
            event = create(:event, start_time: Time.now)
            user  = create(:user, :confirmed)
            participant = create(:event_participant, event: event, user: user)
            login_user user

            get :checkin, id: event.id, checkin_code: event.checkin_code + "not_valid"
            expect(flash[:alert]).to eq(I18n.t('flash.participants.checkin_wrong_checkin_code'))
          end
        end
      end

      context "user hasn't join this event yet" do
        it "should redirect user to event page" do
          event = create(:event, start_time: Time.now)
          user  = create(:user, :confirmed)
          login_user user

          get :checkin, id: event.id, checkin_code: event.checkin_code
          expect(response).to redirect_to event_path(event)
        end

        it "should set error message" do
          event = create(:event, start_time: Time.now)
          user  = create(:user, :confirmed)
          login_user user

          get :checkin, id: event.id, checkin_code: event.checkin_code
          expect(flash[:alert]).to eq(I18n.t('flash.participants.checkin_need_join_first'))
        end
      end

      context "user hasn't sign in" do
        it "should redirect to login page" do
          event = create(:event, start_time: Time.now)

          get :checkin, id: event.id, checkin_code: event.checkin_code
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    context "event.start_time.today? == false" do
      it "should set error message" do
        event = create(:event, start_time: Time.now + 1.day)
        user  = create(:user, :confirmed)
        participant = create(:event_participant, event: event, user: user)
        login_user user

        get :checkin, id: event.id, checkin_code: event.checkin_code
        expect(flash[:alert]).to eq(I18n.t('flash.participants.checkin_in_need_the_same_day_of_event_starttime'))
      end

      it "should redirect to event page" do
        event = create(:event, start_time: Time.now + 1.day)
        user  = create(:user, :confirmed)
        participant = create(:event_participant, event: event, user: user)
        login_user user

        get :checkin, id: event.id, checkin_code: event.checkin_code
        expect(response).to redirect_to event_path(event)
      end
    end
  end
end
