require File.expand_path('../../spec_helper', __FILE__)
require 'cancan/matchers'

describe Ability do
  subject { Ability.new(user) }
  context "when user has not signed in" do
    let(:user) { nil }
    context 'event' do
      it{ should_not be_able_to(:update, create(:event)) }
    end
    context 'order' do
      it{ should_not be_able_to(:confirm_pay, EventOrder) }
    end
  end

  context "when user has signed in" do
    let(:user) { create(:user) }
    context 'event' do
      context 'belongs to him' do
        let(:event) { create(:event, :user => user) }
        it{ should be_able_to(:update, event) }
        it{ should be_able_to(:update, event.group) }
      end
      context 'belongs to others' do
        let(:event) { create(:event) }
        it{ should_not be_able_to(:update, event) }
        it{ should_not be_able_to(:update, event.group) }
        context 'he is the collaborator' do
          let(:collaborator) { create(:group_collaborator, group_id: event.group.id, user_id: user.id) }
          before { collaborator }
          it{ should be_able_to(:create, Event) }
          it{ should be_able_to(:update, event) }
        end
      end
      context 'order' do
        it{ should_not be_able_to(:confirm_pay, EventOrder) }
      end
    end

    context "when admin has signed in" do
      let(:user) { create(:user, :admin) }
      context 'order' do
        it{ should be_able_to(:confirm_pay, EventOrder) }
      end
    end
  end
end
