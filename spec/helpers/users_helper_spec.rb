require 'spec_helper'

describe UsersHelper do
  describe 'gravatar_for' do
    let(:user) { build :user }
    context 'when user is nil' do
      subject { helper.gravatar_for(nil) }
      it { should == '' }
    end

    context 'when no size is provided' do
      subject { helper.gravatar_for(user) }
      it { should have_selector('img.gravatar') }
      it { should =~ /s=36/ }
    end

    context 'when specify the size' do
      subject { helper.gravatar_for(user, 48) }
      it { should =~ /s=48/ }
    end

    context 'when email is blank' do
      subject { helper.gravatar_for(user) }

      before { user.email = nil }
      it { should have_selector('img.gravatar') }
    end
  end
end
