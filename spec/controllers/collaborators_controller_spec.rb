require 'spec_helper'

describe CollaboratorsController do
  let(:user) { login_user }
  let(:partner) { create(:user) }
  let(:event) { create(:event, user: user) }
  let(:collaborator) { create(:group_collaborator, user_id: partner.id, group_id: event.group.id) }

  describe "GET 'index'" do
    before { collaborator }
    it "renders the participant list" do
      get :index, event_id: event.id
      assigns[:collaborators].first[:id].should eql collaborator.id
    end
  end
  describe "POST 'create'" do
    it 'creates the collaborator' do
      expect {
        post :create, event_id: event.id, login: partner.login
      }.to change{GroupCollaborator.count}.by(1)
    end
  end
  describe "DELETE 'destroy'" do
    before { collaborator }
    it 'destroy the collaborator' do
      expect {
        delete :destroy, event_id: event.id, id: collaborator.id
      }.to change{GroupCollaborator.count}.by(-1)
    end
  end
end
