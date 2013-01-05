require 'spec_helper'

describe EventsController do

  describe "GET 'new'" do
    context 'when user has signed in' do
      login_user
      it "builds a new event" do
        get 'new'
        assigns[:event].should be_a_kind_of(Event)
        assigns[:event].should be_a_new_record
      end

      it "renders the new event form" do
        get 'new'
        response.should render_template('new')
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

      context 'post with compound_start_time_attributes' do
        let(:compound_start_time_attributes) do
          {
            'date' => '2013-12-31',
            'hour' => '12',
            'meridian' => 'pm',
            'min' => '10',
            'sec' => '30'
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
end
