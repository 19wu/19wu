require File.expand_path('../../spec_helper', __FILE__)
require 'cancan/matchers'

describe Ability do

  subject { Ability.new(current_user) }

  describe "when user has not signed in" do
    let(:current_user) { nil }

    it 'he can not read all events' do
      should_not be_able_to(:index, Event)
    end

    it 'he can read someone event' do
      should be_able_to(:show, Event)
    end

    it 'he can not create event' do
      should_not be_able_to(:create, Event)
    end

    it 'he can not update any event' do
      should_not be_able_to(:update, Event)
    end

    it 'he can not destroy any event' do
      should_not be_able_to(:destroy, Event)
    end

    it 'he can not see how people joined event' do
      should_not be_able_to(:joined, Event)
    end

    it 'he can not join any event' do
      should_not be_able_to(:joined, Event)
    end
  end

  describe "whan user has signed in" do
    let(:current_user) { FactoryGirl.create(:user) }
    let(:own_event) { FactoryGirl.create(:event, :user => current_user) }

    it 'he can read all events' do
      should be_able_to(:index, Event)
    end

    it 'he can read someone event' do
      should be_able_to(:show, Event)
    end

    it 'he can create event' do
      should be_able_to(:create, Event)
    end

    it 'he can see how people joined this event' do
      should be_able_to(:joined, own_event)
    end

    context 'then he created event' do
      it 'he can update this event' do
        should be_able_to(:update, own_event)
      end

      it 'he can destroy this event' do
        should be_able_to(:destroy, own_event)
      end

      it 'he can join this event' do
        should be_able_to(:join, own_event)
      end
    end

    context 'then other person created event' do
      let(:other_event) { FactoryGirl.create(:event, :user => FactoryGirl.create(:user)) }

      it 'he can not update this event' do
        should_not be_able_to(:update, other_event)
      end

      it 'he can not destroy this event' do
        should_not be_able_to(:destroy, other_event)
      end

      it 'he can join this event' do
        should be_able_to(:join, other_event)
      end
    end
  end
end
