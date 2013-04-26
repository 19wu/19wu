require File.expand_path('../../spec_helper', __FILE__)
require 'cancan/matchers'

describe Ability do
  subject { Ability.new(user) }
  context "when user has not signed in" do
    let(:user) { nil }
    it{ should_not be_able_to(:update, create(:event)) }
  end

  context "whan user has signed in" do
    let(:user) { create(:user) }
    context 'event belongs to him' do
      let(:event) { create(:event, :user => user) }
      it{ should be_able_to(:update, event) }
    end
    context 'event belongs to others' do
      let(:event) { create(:event) }
      it{ should_not be_able_to(:update, event) }
    end
  end
end
