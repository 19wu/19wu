require 'spec_helper'

describe InvitationsController do
  as_user
  let(:email) { 'demo@19wu.com' }

  context 'issue' do
    describe '#284' do
      subject { ActionMailer::Base.deliveries.last }
      before { post :create, user: { email: email } }
      it { should be_nil }
    end
  end
end
